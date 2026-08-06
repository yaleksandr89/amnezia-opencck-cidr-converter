#requires -Version 5.1
<#
.SYNOPSIS
Converts an OpenCCK IPv4 CIDR list into JSON suitable for importing into AmneziaVPN.

.DESCRIPTION
OpenCCK can return IPv4 CIDR values in the "hostname" field. Some AmneziaVPN 5.x
imports treat that value as a hostname and lose the CIDR prefix. This script moves
the CIDR value into "ip" and assigns a unique service name under the reserved
.invalid domain to "hostname".

This is the native Windows implementation. macOS and Linux use the Bash implementation.
#>

[CmdletBinding(DefaultParameterSetName = 'Url')]
param(
    [Parameter(ParameterSetName = 'Url')]
    [string]$SourceUrl,

    [Parameter(Mandatory, ParameterSetName = 'File')]
    [string]$InputPath,

    [Parameter()]
    [string]$OutputPath
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

try {
    [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
} catch {
    # Console encoding does not affect conversion.
}

$ScriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
if ([string]::IsNullOrWhiteSpace($ScriptDirectory)) {
    $ScriptDirectory = (Get-Location).Path
}

$ProjectRoot = Split-Path -Parent $ScriptDirectory
if ([string]::IsNullOrWhiteSpace($ProjectRoot)) {
    $ProjectRoot = $ScriptDirectory
}

function Resolve-OutputPath {
    param(
        [Parameter()]
        [string]$Value
    )

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return Join-Path -Path $ProjectRoot -ChildPath 'amnezia-opencck-cidr.json'
    }

    if ([System.IO.Path]::IsPathRooted($Value)) {
        return [System.IO.Path]::GetFullPath($Value)
    }

    return [System.IO.Path]::GetFullPath((Join-Path -Path (Get-Location).Path -ChildPath $Value))
}

function Read-OpenCckUrl {
    Write-Host ''
    Write-Host '============================================================'
    Write-Host ' Конвертер CIDR OpenCCK для AmneziaVPN'
    Write-Host '============================================================'
    Write-Host ''
    Write-Host '1. Откройте: https://iplist.opencck.org/'
    Write-Host '2. Выберите нужные ресурсы.'
    Write-Host '3. Формат: Amnezia.'
    Write-Host '4. Тип данных: IP-зоны IPv4 (CIDR).'
    Write-Host ''
    Write-Host 'ВАЖНО: пункт «Сохранить как файл» должен быть выключен.' -ForegroundColor Yellow
    Write-Host 'Скопируйте длинную ссылку из нижнего поля страницы.'
    Write-Host ''

    return Read-Host 'Вставьте ссылку OpenCCK и нажмите Enter'
}

function ConvertFrom-QueryString {
    param(
        [Parameter(Mandatory)]
        [string]$Query
    )

    $parameters = @{}

    foreach ($part in ($Query.TrimStart('?') -split '&')) {
        if ([string]::IsNullOrWhiteSpace($part)) {
            continue
        }

        $pair = $part -split '=', 2
        $name = [System.Uri]::UnescapeDataString($pair[0].Replace('+', ' '))
        $value = if ($pair.Count -gt 1) {
            [System.Uri]::UnescapeDataString($pair[1].Replace('+', ' '))
        } else {
            ''
        }

        if (-not $parameters.ContainsKey($name)) {
            $parameters[$name] = New-Object 'System.Collections.Generic.List[string]'
        }

        $parameters[$name].Add($value)
    }

    return $parameters
}

function Normalize-SourceUrl {
    param(
        [Parameter(Mandatory)]
        [string]$Value
    )

    if ([string]::IsNullOrWhiteSpace($Value)) {
        throw 'Ссылка не введена.'
    }

    $normalized = $Value.Trim()

    if (($normalized.StartsWith('"') -and $normalized.EndsWith('"')) -or
        ($normalized.StartsWith("'") -and $normalized.EndsWith("'"))) {
        $normalized = $normalized.Substring(1, $normalized.Length - 2).Trim()
    }

    $normalized = $normalized.Replace('&amp;', '&')

    $uri = $null
    if (-not [System.Uri]::TryCreate($normalized, [System.UriKind]::Absolute, [ref]$uri)) {
        throw 'Введена некорректная ссылка.'
    }

    if ($uri.Scheme -ine 'https') {
        throw 'Ссылка должна начинаться с https://'
    }

    if ($uri.DnsSafeHost -ine 'iplist.opencck.org') {
        throw 'Ожидалась ссылка с сайта iplist.opencck.org'
    }

    $parameters = ConvertFrom-QueryString -Query $uri.Query

    if (-not $parameters.ContainsKey('format') -or
        -not ($parameters['format'] -icontains 'amnezia')) {
        throw 'В ссылке не найден параметр format=amnezia. Выберите формат «Amnezia».'
    }

    if (-not $parameters.ContainsKey('data') -or
        -not ($parameters['data'] -icontains 'cidr4')) {
        throw 'В ссылке не найден параметр data=cidr4. Выберите «IP-зоны IPv4 (CIDR)».'
    }

    if (-not $parameters.ContainsKey('site') -or $parameters['site'].Count -eq 0) {
        throw 'В ссылке нет выбранных ресурсов (параметров site=...).'
    }

    return $uri.AbsoluteUri
}

function Test-IPv4Cidr {
    param(
        [Parameter(Mandatory)]
        [string]$Value
    )

    if ($Value -notmatch '^(?<address>(\d{1,3}\.){3}\d{1,3})/(?<prefix>[0-9]|[12][0-9]|3[0-2])$') {
        return $false
    }

    $parsedIp = $null
    if (-not [System.Net.IPAddress]::TryParse($Matches.address, [ref]$parsedIp)) {
        return $false
    }

    return $parsedIp.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork
}

function Read-SourceItems {
    param(
        [Parameter()]
        [string]$Url,

        [Parameter()]
        [string]$Path
    )

    if (-not [string]::IsNullOrWhiteSpace($Path)) {
        $resolvedInputPath = (Resolve-Path -LiteralPath $Path).Path
        Write-Host "Читаю локальный файл: $resolvedInputPath"

        $rawJson = [System.IO.File]::ReadAllText($resolvedInputPath)
        if ([string]::IsNullOrWhiteSpace($rawJson)) {
            throw 'Входной JSON-файл пуст.'
        }

        return @($rawJson | ConvertFrom-Json)
    }

    $normalizedUrl = Normalize-SourceUrl -Value $Url

    # Required by some older Windows PowerShell installations; harmless in PowerShell 7.
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    Write-Host 'Скачиваю актуальный список OpenCCK...'
    $response = Invoke-RestMethod -Uri $normalizedUrl -Method Get -TimeoutSec 120

    if ($null -eq $response) {
        throw 'OpenCCK вернул пустой ответ.'
    }

    return @($response)
}

function Convert-OpenCckItems {
    param(
        [Parameter(Mandatory)]
        [object[]]$Items
    )

    $result = [System.Collections.Generic.List[object]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $index = 0

    foreach ($item in $Items) {
        if ($null -eq $item) {
            continue
        }

        $hostnameProperty = $item.PSObject.Properties['hostname']
        if ($null -eq $hostnameProperty) {
            Write-Warning 'Пропущена запись без поля hostname.'
            continue
        }

        $cidr = [string]$hostnameProperty.Value
        if ([string]::IsNullOrWhiteSpace($cidr)) {
            continue
        }

        $cidr = $cidr.Trim()

        if (-not (Test-IPv4Cidr -Value $cidr)) {
            Write-Warning "Пропущена некорректная IPv4 CIDR-запись: $cidr"
            continue
        }

        if (-not $seen.Add($cidr)) {
            continue
        }

        $index++
        $result.Add([PSCustomObject]@{
            hostname = ('route-{0:D6}.invalid' -f $index)
            ip       = $cidr
        })
    }

    return @($result.ToArray())
}

function Write-ResultJson {
    param(
        [Parameter(Mandatory)]
        [object[]]$Items,

        [Parameter(Mandatory)]
        [string]$Path
    )

    if ($Items.Count -eq 0) {
        throw 'Не удалось получить ни одной корректной CIDR-записи.'
    }

    $outputDirectory = Split-Path -Parent $Path
    if (-not [string]::IsNullOrWhiteSpace($outputDirectory) -and
        -not (Test-Path -LiteralPath $outputDirectory)) {
        New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
    }

    $json = ConvertTo-Json -InputObject @($Items) -Depth 3
    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($Path, $json, $utf8NoBom)
}

try {
    $OutputPath = Resolve-OutputPath -Value $OutputPath

    if ($PSCmdlet.ParameterSetName -eq 'Url' -and [string]::IsNullOrWhiteSpace($SourceUrl)) {
        $SourceUrl = Read-OpenCckUrl
    }

    $sourceItems = if ($PSCmdlet.ParameterSetName -eq 'File') {
        Read-SourceItems -Path $InputPath
    } else {
        Read-SourceItems -Url $SourceUrl
    }

    $result = Convert-OpenCckItems -Items $sourceItems
    Write-ResultJson -Items $result -Path $OutputPath

    Write-Host ''
    Write-Host 'Готово.' -ForegroundColor Green
    Write-Host "Количество маршрутов: $($result.Count)"
    Write-Host "Файл: $OutputPath"
    Write-Host ''
    Write-Host 'Импортируйте созданный JSON в приложение.'
}
catch {
    Write-Host ''
    Write-Host "Ошибка: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
