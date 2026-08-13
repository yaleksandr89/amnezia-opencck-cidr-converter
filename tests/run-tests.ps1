#requires -Version 5.1
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

function Assert-Equal {
    param(
        [Parameter(Mandatory)]
        $Expected,

        [Parameter(Mandatory)]
        $Actual,

        [Parameter(Mandatory)]
        [string]$Message
    )

    if ($Expected -ne $Actual) {
        throw "$Message Expected: '$Expected'; actual: '$Actual'."
    }
}

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$converter = Join-Path $repositoryRoot 'src/convert-opencck-cidr.ps1'
$fixture = Join-Path $PSScriptRoot 'fixtures/opencck-sample.json'
$tempDirectory = Join-Path ([System.IO.Path]::GetTempPath()) ('amnezia-opencck-tests-' + [Guid]::NewGuid().ToString('N'))
$output = Join-Path $tempDirectory 'result.json'
$russianOutput = Join-Path $tempDirectory 'result-ru.json'
$passThruOutput = Join-Path $tempDirectory 'result-pass-thru.json'
$passThruErrorOutput = Join-Path $tempDirectory 'result-pass-thru-error.json'
$relativeOutputName = 'relative-result-' + [Guid]::NewGuid().ToString('N') + '.json'
$relativeOutput = Join-Path (Get-Location).ProviderPath $relativeOutputName

try {
    New-Item -ItemType Directory -Path $tempDirectory -Force | Out-Null

    & $converter -InputPath $fixture -OutputPath $output -Language en

    if (-not (Test-Path -LiteralPath $output)) {
        throw 'Converter did not create the output file.'
    }

    $parsedItems = [System.IO.File]::ReadAllText($output) | ConvertFrom-Json
    $items = if ($parsedItems -is [System.Array]) {
        $parsedItems
    } else {
        @($parsedItems)
    }

    Assert-Equal 3 $items.Count 'Unexpected number of converted routes.'
    Assert-Equal 'route-000001.invalid' $items[0].hostname 'Unexpected first hostname.'
    Assert-Equal '142.250.0.0/15' $items[0].ip 'Unexpected first CIDR.'
    Assert-Equal 'route-000002.invalid' $items[1].hostname 'Unexpected second hostname.'
    Assert-Equal '1.1.1.0/24' $items[1].ip 'Unexpected second CIDR.'
    Assert-Equal 'route-000003.invalid' $items[2].hostname 'Unexpected third hostname.'
    Assert-Equal '192.0.2.0/24' $items[2].ip 'Unexpected third CIDR.'

    $bytes = [System.IO.File]::ReadAllBytes($output)
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        throw 'Output JSON must be UTF-8 without BOM.'
    }

    & $converter `
    -InputPath $fixture `
    -OutputPath $relativeOutputName `
    -Language en

    if (-not (Test-Path -LiteralPath $relativeOutput)) {
        throw 'Converter did not create the output file from a relative output path.'
    }

    Assert-Equal (
    [System.IO.File]::ReadAllText($output)
    ) (
    [System.IO.File]::ReadAllText($relativeOutput)
    ) 'Relative output path produced different JSON.'

    $passThruResult = & $converter `
    -InputPath $fixture `
    -OutputPath $passThruOutput `
    -Language en `
    -PassThru

    Assert-Equal $true $passThruResult.Success 'PassThru success flag is incorrect.'
    Assert-Equal 3 $passThruResult.RouteCount 'PassThru route count is incorrect.'
    Assert-Equal $passThruOutput $passThruResult.OutputPath 'PassThru output path is incorrect.'

    if ($null -ne $passThruResult.ErrorMessage) {
        throw 'PassThru success result contains an error message.'
    }

    $passThruErrorResult = & $converter `
    -SourceUrl 'https://example.com/not-opencck' `
    -OutputPath $passThruErrorOutput `
    -Language en `
    -PassThru

    Assert-Equal $false $passThruErrorResult.Success 'PassThru error flag is incorrect.'
    Assert-Equal 0 $passThruErrorResult.RouteCount 'PassThru error route count is incorrect.'
    Assert-Equal $passThruErrorOutput $passThruErrorResult.OutputPath 'PassThru error output path is incorrect.'
    Assert-Equal 'Expected a URL from iplist.opencck.org' $passThruErrorResult.ErrorMessage 'PassThru error message is incorrect.'

    if (Test-Path -LiteralPath $passThruErrorOutput) {
        throw 'PassThru failed conversion unexpectedly created an output file.'
    }

    & $converter -InputPath $fixture -OutputPath $russianOutput -Language ru

    if (-not (Test-Path -LiteralPath $russianOutput)) {
        throw 'Converter did not create the output file with Russian UI.'
    }

    Assert-Equal (
        [System.IO.File]::ReadAllText($output)
    ) (
        [System.IO.File]::ReadAllText($russianOutput)
    ) 'Localized runs produced different JSON.'

    Write-Host 'All tests passed.' -ForegroundColor Green
}
finally {
    if (Test-Path -LiteralPath $relativeOutput) {
        Remove-Item -LiteralPath $relativeOutput -Force
    }

    if (Test-Path -LiteralPath $tempDirectory) {
        Remove-Item -LiteralPath $tempDirectory -Recurse -Force
    }
}
