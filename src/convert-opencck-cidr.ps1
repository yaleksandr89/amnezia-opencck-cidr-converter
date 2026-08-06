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

.PARAMETER Language
Interface language: auto, ru, or en. Auto uses the current Windows UI culture.
#>

[CmdletBinding(DefaultParameterSetName = 'Url')]
param(
    [Parameter(ParameterSetName = 'Url')]
    [string]$SourceUrl,

    [Parameter(Mandatory, ParameterSetName = 'File')]
    [string]$InputPath,

    [Parameter()]
    [string]$OutputPath,

    [Parameter()]
    [ValidateSet('auto', 'ru', 'en')]
    [string]$Language = 'auto'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

try {
    [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
} catch {
    # Console encoding does not affect conversion.
}

$ScriptLanguage = if ($Language -eq 'auto') {
    if ([System.Globalization.CultureInfo]::CurrentUICulture.TwoLetterISOLanguageName -eq 'ru') {
        'ru'
    } else {
        'en'
    }
} else {
    $Language
}

$Messages = @{
    ru = @{
        Title = ' Конвертер CIDR OpenCCK для AmneziaVPN'
        Open = '1. Откройте: https://iplist.opencck.org/'
        Select = '2. Выберите нужные ресурсы.'
        Format = '3. Формат: Amnezia.'
        DataType = '4. Тип данных: IP-зоны IPv4 (CIDR).'
        SaveWarning = 'ВАЖНО: пункт «Сохранить как файл» должен быть выключен.'
        CopyUrl = 'Скопируйте длинную ссылку из нижнего поля страницы.'
        PasteUrl = 'Вставьте ссылку OpenCCK и нажмите Enter'
        UrlEmpty = 'Ссылка не введена.'
        UrlInvalid = 'Введена некорректная ссылка.'
        UrlHttps = 'Ссылка должна начинаться с https://'
        UrlHost = 'Ожидалась ссылка с сайта iplist.opencck.org'
        UrlFormat = 'В ссылке не найден параметр format=amnezia. Выберите формат «Amnezia».'
        UrlData = 'В ссылке не найден параметр data=cidr4. Выберите «IP-зоны IPv4 (CIDR)».'
        UrlSites = 'В ссылке нет выбранных ресурсов (параметров site=...).'
        ReadFile = 'Читаю локальный файл: {0}'
        EmptyFile = 'Входной JSON-файл пуст.'
        Downloading = 'Скачиваю актуальный список OpenCCK...'
        EmptyResponse = 'OpenCCK вернул пустой ответ.'
        MissingHostname = 'Пропущена запись без поля hostname.'
        InvalidCidr = 'Пропущена некорректная IPv4 CIDR-запись: {0}'
        NoValidRoutes = 'Не удалось получить ни одной корректной CIDR-записи.'
        Done = 'Готово.'
        RouteCount = 'Количество маршрутов: {0}'
        File = 'Файл: {0}'
        Import = 'Импортируйте созданный JSON в приложение.'
        Error = 'Ошибка: {0}'
    }
    en = @{
        Title = ' OpenCCK CIDR Converter for AmneziaVPN'
        Open = '1. Open: https://iplist.opencck.org/'
        Select = '2. Select the required resources.'
        Format = '3. Format: Amnezia.'
        DataType = '4. Data type: IPv4 CIDR ranges.'
        SaveWarning = 'IMPORTANT: disable the "Save as file" option.'
        CopyUrl = 'Copy the long URL from the field at the bottom of the page.'
        PasteUrl = 'Paste the OpenCCK URL and press Enter'
        UrlEmpty = 'The URL was not provided.'
        UrlInvalid = 'The URL is invalid.'
        UrlHttps = 'The URL must start with https://'
        UrlHost = 'Expected a URL from iplist.opencck.org'
        UrlFormat = 'The URL does not contain format=amnezia. Select the Amnezia format.'
        UrlData = 'The URL does not contain data=cidr4. Select IPv4 CIDR ranges.'
        UrlSites = 'The URL does not contain selected resources (site=... parameters).'
        ReadFile = 'Reading local file: {0}'
        EmptyFile = 'The input JSON file is empty.'
        Downloading = 'Downloading the current OpenCCK list...'
        EmptyResponse = 'OpenCCK returned an empty response.'
        MissingHostname = 'Skipped an entry without the hostname field.'
        InvalidCidr = 'Skipped invalid IPv4 CIDR entry: {0}'
        NoValidRoutes = 'No valid CIDR entries were found.'
        Done = 'Done.'
        RouteCount = 'Route count: {0}'
        File = 'File: {0}'
        Import = 'Import the generated JSON into the application.'
        Error = 'Error: {0}'
    }
}

function Get-Message {
    param(
        [Parameter(Mandatory)]
        [string]$Key,

        [Parameter()]
        [object[]]$Arguments
    )

    $template = $Messages[$ScriptLanguage][$Key]
    if ($null -eq $template) {
        throw "Unknown message key: $Key"
    }

    if ($null -ne $Arguments -and $Arguments.Count -gt 0) {
        return ($template -f $Arguments)
    }

    return $template
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
    Write-Host (Get-Message 'Title')
    Write-Host '============================================================'
    Write-Host ''
    Write-Host (Get-Message 'Open')
    Write-Host (Get-Message 'Select')
    Write-Host (Get-Message 'Format')
    Write-Host (Get-Message 'DataType')
    Write-Host ''
    Write-Host (Get-Message 'SaveWarning') -ForegroundColor Yellow
    Write-Host (Get-Message 'CopyUrl')
    Write-Host ''

    return Read-Host (Get-Message 'PasteUrl')
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
        throw (Get-Message 'UrlEmpty')
    }

    $normalized = $Value.Trim()

    if (($normalized.StartsWith('"') -and $normalized.EndsWith('"')) -or
        ($normalized.StartsWith("'") -and $normalized.EndsWith("'"))) {
        $normalized = $normalized.Substring(1, $normalized.Length - 2).Trim()
    }

    $normalized = $normalized.Replace('&amp;', '&')

    $uri = $null
    if (-not [System.Uri]::TryCreate($normalized, [System.UriKind]::Absolute, [ref]$uri)) {
        throw (Get-Message 'UrlInvalid')
    }

    if ($uri.Scheme -ine 'https') {
        throw (Get-Message 'UrlHttps')
    }

    if ($uri.DnsSafeHost -ine 'iplist.opencck.org') {
        throw (Get-Message 'UrlHost')
    }

    $parameters = ConvertFrom-QueryString -Query $uri.Query

    if (-not $parameters.ContainsKey('format') -or
        -not ($parameters['format'] -icontains 'amnezia')) {
        throw (Get-Message 'UrlFormat')
    }

    if (-not $parameters.ContainsKey('data') -or
        -not ($parameters['data'] -icontains 'cidr4')) {
        throw (Get-Message 'UrlData')
    }

    if (-not $parameters.ContainsKey('site') -or $parameters['site'].Count -eq 0) {
        throw (Get-Message 'UrlSites')
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
        Write-Host (Get-Message 'ReadFile' @($resolvedInputPath))

        $rawJson = [System.IO.File]::ReadAllText($resolvedInputPath)
        if ([string]::IsNullOrWhiteSpace($rawJson)) {
            throw (Get-Message 'EmptyFile')
        }

        return @($rawJson | ConvertFrom-Json)
    }

    $normalizedUrl = Normalize-SourceUrl -Value $Url

    # Required by some older Windows PowerShell installations; harmless in PowerShell 7.
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    Write-Host (Get-Message 'Downloading')
    $response = Invoke-RestMethod -Uri $normalizedUrl -Method Get -TimeoutSec 120

    if ($null -eq $response) {
        throw (Get-Message 'EmptyResponse')
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
            Write-Warning (Get-Message 'MissingHostname')
            continue
        }

        $cidr = [string]$hostnameProperty.Value
        if ([string]::IsNullOrWhiteSpace($cidr)) {
            continue
        }

        $cidr = $cidr.Trim()

        if (-not (Test-IPv4Cidr -Value $cidr)) {
            Write-Warning (Get-Message 'InvalidCidr' @($cidr))
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
        throw (Get-Message 'NoValidRoutes')
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
    Write-Host (Get-Message 'Done') -ForegroundColor Green
    Write-Host (Get-Message 'RouteCount' @($result.Count))
    Write-Host (Get-Message 'File' @($OutputPath))
    Write-Host ''
    Write-Host (Get-Message 'Import')
}
catch {
    Write-Host ''
    Write-Host (Get-Message 'Error' @($_.Exception.Message)) -ForegroundColor Red
    exit 1
}
