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

function Assert-NoTempFiles {
    if (Get-ChildItem -LiteralPath $tempDirectory -Force -Recurse -Filter '.amnezia-opencck-output.*') {
        throw 'A temporary conversion file remains.'
    }
}

function Assert-ConversionFailure {
    param($Result, [string]$Path)

    Assert-Equal $false $Result.Success 'Failed conversion reported success.'
    Assert-Equal 0 $Result.RouteCount 'Failed conversion reported routes.'
    Assert-Equal $Path $Result.OutputPath 'Failed conversion reported a different output path.'
    if ([string]::IsNullOrWhiteSpace($Result.ErrorMessage)) {
        throw 'Failed conversion returned no diagnostic.'
    }
    Assert-NoTempFiles
}

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$converter = Join-Path $repositoryRoot 'src/convert-opencck-cidr.ps1'
$launcher = Join-Path $repositoryRoot 'bin/convert-opencck-cidr.cmd'
$fixture = Join-Path $PSScriptRoot 'fixtures/opencck-sample.json'
$tempDirectory = Join-Path ([System.IO.Path]::GetTempPath()) ('amnezia-opencck-tests-' + [Guid]::NewGuid().ToString('N'))
$output = Join-Path $tempDirectory 'result.json'
$russianOutput = Join-Path $tempDirectory 'result-ru.json'
$passThruOutput = Join-Path $tempDirectory 'result-pass-thru.json'
$passThruErrorOutput = Join-Path $tempDirectory 'result-pass-thru-error.json'
$relativeOutputName = 'relative-result.json'
$relativeOutput = Join-Path $tempDirectory $relativeOutputName

New-Item -ItemType Directory -Path $tempDirectory | Out-Null
Push-Location -LiteralPath $tempDirectory
try {
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

    $inputName = 'payload= [source]!.json'
    $literalInput = Join-Path $tempDirectory $inputName
    $destinationDirectory = Join-Path $tempDirectory '[results]'
    $literalOutput = Join-Path $destinationDirectory 'result [test]!.json'
    $missingOutput = Join-Path $tempDirectory 'absent.json'
    [System.IO.File]::Copy($fixture, $literalInput)
    $fixtureBytes = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($fixture))
    $samePath = & $converter -InputPath $literalInput -OutputPath $literalInput -Language en -PassThru
    Assert-ConversionFailure $samePath $literalInput
    Assert-Equal 'Input and output must be different files.' $samePath.ErrorMessage 'Missing same-path diagnostic.'
    $aliasPath = & $converter -InputPath ".\$inputName" -OutputPath $literalInput.ToUpperInvariant() -Language ru -PassThru
    Assert-ConversionFailure $aliasPath $literalInput
    Assert-Equal 'Входной и выходной файлы должны различаться.' $aliasPath.ErrorMessage 'Missing localized same-path diagnostic.'
    Assert-Equal $fixtureBytes ([Convert]::ToBase64String([System.IO.File]::ReadAllBytes($literalInput))) 'Input bytes changed.'

    [void][System.IO.Directory]::CreateDirectory($destinationDirectory)
    $sentinel = [byte[]]@(0, 255, 13, 10, 42)
    [System.IO.File]::WriteAllBytes($literalOutput, $sentinel)
    $sentinelBase64 = [Convert]::ToBase64String($sentinel)
    $testInput = Join-Path $tempDirectory 'cases.json'
    [System.IO.File]::WriteAllText($testInput, '[]')
    $empty = & $converter -InputPath $testInput -OutputPath $literalOutput -Language en -PassThru
    Assert-ConversionFailure $empty $literalOutput
    Assert-Equal 'No valid CIDR entries were found.' $empty.ErrorMessage 'Missing empty-list diagnostic.'
    Assert-Equal $sentinelBase64 ([Convert]::ToBase64String([System.IO.File]::ReadAllBytes($literalOutput))) 'Empty list changed prior bytes.'
    $empty = & $converter -InputPath $testInput -OutputPath $missingOutput -Language ru -PassThru
    Assert-ConversionFailure $empty $missingOutput
    Assert-Equal 'Не удалось получить ни одной корректной CIDR-записи.' $empty.ErrorMessage 'Missing localized empty-list diagnostic.'
    Assert-Equal $false (Test-Path -LiteralPath $missingOutput) 'Empty list created a result.'

    $directoryOutput = & $converter -InputPath $literalInput -OutputPath $destinationDirectory -Language en -PassThru
    Assert-ConversionFailure $directoryOutput $destinationDirectory
    Assert-Equal "The output path must refer to an ordinary file: $destinationDirectory" $directoryOutput.ErrorMessage 'Missing directory diagnostic.'
    Assert-Equal 1 @(Get-ChildItem -LiteralPath $destinationDirectory -Force).Count 'Directory contents changed.'
    Assert-Equal $sentinelBase64 ([Convert]::ToBase64String([System.IO.File]::ReadAllBytes($literalOutput))) 'Directory conversion changed prior bytes.'

    $locked = [System.IO.File]::Open($literalOutput, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read)
    try {
        $replaceFailure = & $converter -InputPath $literalInput -OutputPath $literalOutput -Language en -PassThru
        Assert-ConversionFailure $replaceFailure $literalOutput
        Assert-Equal $sentinelBase64 ([Convert]::ToBase64String([System.IO.File]::ReadAllBytes($literalOutput))) 'Failed replacement changed prior bytes.'
    } finally {
        $locked.Dispose()
    }

    $replacement = & $converter -InputPath $inputName -OutputPath $literalOutput -Language en -PassThru
    Assert-Equal $true $replacement.Success 'Could not replace an ordinary output.'
    Assert-Equal 3 $replacement.RouteCount 'Replacement reported a different route count.'
    $expectedJson = [System.IO.File]::ReadAllText($output)
    Assert-Equal $expectedJson ([System.IO.File]::ReadAllText($literalOutput)) 'Replacement produced different JSON.'

    foreach ($invalidJson in @(
        'garbage {"hostname":"192.0.2.0/24"} garbage',
        '[{"hostname":"192.0.2.0/24"}',
        '[{"hostname":"192.0.2.0/24","value":[1]',
        '[{"hostname":"192.0.2.0/24"}] garbage',
        '[{"hostname":"192.0.2.0/24","value":"\x"}]'
    )) {
        [System.IO.File]::WriteAllText($testInput, $invalidJson)
        $invalid = & $converter -InputPath $testInput -OutputPath $literalOutput -Language en -PassThru
        if ($invalid.Success) {
            throw "Malformed JSON was accepted: $invalidJson"
        }
        Assert-ConversionFailure $invalid $literalOutput
        Assert-Equal $expectedJson ([System.IO.File]::ReadAllText($literalOutput)) 'Malformed JSON changed the prior result.'
    }

    foreach ($nonRecords in @(
        '[[{"hostname":"198.51.100.0/24"}]]',
        '[{"meta":{"hostname":"192.0.2.0/24"}},[{"hostname":"198.51.100.0/24"}],{"hostname":["203.0.113.0/24"]},"{\"hostname\":\"192.0.2.0/24\"}"]'
    )) {
        [System.IO.File]::WriteAllText($testInput, $nonRecords)
        $nested = & $converter -InputPath $testInput -OutputPath $missingOutput -Language en -PassThru
        Assert-ConversionFailure $nested $missingOutput
        Assert-Equal 'No valid CIDR entries were found.' $nested.ErrorMessage 'Nested fields were treated as routes.'
        Assert-Equal $false (Test-Path -LiteralPath $missingOutput) 'Nested fields created a result.'
    }

    $escapedJson = @'
[
  null, false, 4, ["irrelevant"],
  {"note":"{\"hostname\":\"198.51.100.0/24\"}","meta":{"any":[{},[],true,-12.5e+2,"\u00e9"]},
   "host\u006eame":"\t142.250.0.0\/15\u0020"},
  {"hostname":"142.250.0.0/15"},
  {"hostname":"1.1.1.0\u002f24","meta":{"hostname":"203.0.113.0/24"}},
  {"hostname":"192.0.2.0/24"}
]
'@
    [System.IO.File]::WriteAllText($testInput, $escapedJson, [System.Text.UTF8Encoding]::new($true))
    $escaped = & $converter -InputPath $testInput -OutputPath $literalOutput -Language en -PassThru
    Assert-Equal $true $escaped.Success "Escaped JSON failed conversion. $($escaped.ErrorMessage)"
    Assert-Equal 3 $escaped.RouteCount 'Escaped JSON produced the wrong route count.'
    Assert-Equal $expectedJson ([System.IO.File]::ReadAllText($literalOutput)) 'Escaped JSON produced a different result.'

    foreach ($oneRoute in @(
        '{"hostname":"192.0.2.0/24","meta":{"hostname":"203.0.113.0/24"}}',
        '[{"hostname":"192.0.2.0/24"}]'
    )) {
        [System.IO.File]::WriteAllText($testInput, $oneRoute)
        $single = & $converter -InputPath $testInput -OutputPath $literalOutput -Language en -PassThru
        Assert-Equal $true $single.Success 'A single route failed conversion.'
        Assert-Equal 1 $single.RouteCount 'Single route count is incorrect.'
        $singleJson = [System.IO.File]::ReadAllText($literalOutput)
        if (-not $singleJson.TrimStart().StartsWith('[')) {
            throw 'A single route was not written as an array.'
        }
        $singleItem = $singleJson | ConvertFrom-Json
        Assert-Equal 'route-000001.invalid' $singleItem.hostname 'Unexpected single route hostname.'
        Assert-Equal '192.0.2.0/24' $singleItem.ip 'Unexpected single route CIDR.'
    }

    $supportsComments = (Get-Command ConvertFrom-Json).Parameters.ContainsKey('NoEnumerate')
    $commentedArray = @'
[
  // {
  {"hostname":"192.0.2.0/24","note":"// /* \" [["},
]
'@
    $unclosedArray = '[{"hostname":"192.0.2.0/24"} /* ] */'
    if ($supportsComments) {
        foreach ($commentedJson in @(
            '[{"hostname":"192.0.2.0/24"}] /* [ */',
            $commentedArray,
            '[{''hostname'':''192.0.2.0/24'',''note'':''//''}]'
        )) {
            [System.IO.File]::WriteAllText($testInput, $commentedJson)
            $commented = & $converter -InputPath $testInput -OutputPath $literalOutput -Language en -PassThru
            Assert-Equal $true $commented.Success "Commented JSON failed. $($commented.ErrorMessage)"
            Assert-Equal 1 $commented.RouteCount 'Commented JSON produced the wrong route count.'
            Assert-Equal $singleJson ([System.IO.File]::ReadAllText($literalOutput)) 'Commented JSON changed route output.'
        }

        $priorBytes = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($literalOutput))
        [System.IO.File]::WriteAllText($testInput, $unclosedArray)
        $unclosed = & $converter -InputPath $testInput -OutputPath $literalOutput -Language en -PassThru
        Assert-ConversionFailure $unclosed $literalOutput
        Assert-Equal 'The input JSON contains an unclosed array or object.' $unclosed.ErrorMessage 'Missing unclosed-container diagnostic.'
        Assert-Equal $priorBytes ([Convert]::ToBase64String([System.IO.File]::ReadAllBytes($literalOutput))) 'Unclosed JSON changed prior bytes.'
        Write-Host 'PowerShell 7 comment and completeness tests passed.'
    }

    & {
        $sourceUrl = 'https://iplist.opencck.org/?format=amnezia&data=cidr4&site=synthetic-test'
        function Invoke-RestMethod {
            throw 'Unexpected Invoke-RestMethod call in offline URL tests.'
        }
        function Invoke-WebRequest {
            param($Uri, $Method, $TimeoutSec, [switch]$UseBasicParsing)

            Assert-Equal $sourceUrl $Uri 'The stub received an unexpected URL.'
            Assert-Equal 'Get' $Method 'The HTTP method changed.'
            Assert-Equal 120 $TimeoutSec 'The HTTP timeout changed.'
            Assert-Equal $true $UseBasicParsing.IsPresent 'Basic parsing was not requested.'
            if ($null -ne $requestError) {
                throw $requestError
            }
            return [PSCustomObject]@{ Content = $responseBody }
        }

        $requestError = $null
        $responseBody = $escapedJson
        $downloaded = & $converter -SourceUrl $sourceUrl -OutputPath $literalOutput -Language en -PassThru
        Assert-Equal $true $downloaded.Success "Synthetic JSON download failed. $($downloaded.ErrorMessage)"
        Assert-Equal 3 $downloaded.RouteCount 'Synthetic JSON download produced the wrong route count.'
        Assert-Equal $literalOutput $downloaded.OutputPath 'Synthetic JSON download reported a different output path.'
        Assert-Equal $expectedJson ([System.IO.File]::ReadAllText($literalOutput)) 'Synthetic JSON download changed route output.'

        $responseBody = [System.Text.Encoding]::UTF8.GetBytes(([string][char]0xFEFF) + '{"hostname":"192.0.2.0/24"}')
        $downloaded = & $converter -SourceUrl $sourceUrl -OutputPath $literalOutput -Language en -PassThru
        Assert-Equal $true $downloaded.Success "Synthetic byte response failed. $($downloaded.ErrorMessage)"
        Assert-Equal 1 $downloaded.RouteCount 'Synthetic byte response produced the wrong route count.'
        Assert-Equal $singleJson ([System.IO.File]::ReadAllText($literalOutput)) 'Synthetic byte response changed route output.'

        $priorBytes = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($literalOutput))
        $responseBody = if ($supportsComments) { $unclosedArray } else { '[{"hostname":"192.0.2.0/24"}' }
        $downloaded = & $converter -SourceUrl $sourceUrl -OutputPath $literalOutput -Language en -PassThru
        Assert-ConversionFailure $downloaded $literalOutput
        if ($supportsComments) {
            Assert-Equal 'The input JSON contains an unclosed array or object.' $downloaded.ErrorMessage 'URL input bypassed the completeness check.'
        }
        Assert-Equal $priorBytes ([Convert]::ToBase64String([System.IO.File]::ReadAllBytes($literalOutput))) 'Malformed HTTP response changed prior bytes.'

        $responseBody = ''
        $downloaded = & $converter -SourceUrl $sourceUrl -OutputPath $literalOutput -Language en -PassThru
        Assert-ConversionFailure $downloaded $literalOutput
        Assert-Equal 'OpenCCK returned an empty response.' $downloaded.ErrorMessage 'Empty HTTP response lost its diagnostic.'

        $requestError = 'Synthetic HTTP failure.'
        $downloaded = & $converter -SourceUrl $sourceUrl -OutputPath $literalOutput -Language en -PassThru
        Assert-ConversionFailure $downloaded $literalOutput
        Assert-Equal $requestError $downloaded.ErrorMessage 'HTTP failure lost its diagnostic.'
        Assert-Equal $priorBytes ([Convert]::ToBase64String([System.IO.File]::ReadAllBytes($literalOutput))) 'HTTP failure changed prior bytes.'
        Write-Host 'Offline URL tests passed.'
    }

    $launcherOutput = & $launcher -InputPath $literalInput -OutputPath $literalOutput -Language en
    Assert-Equal 0 $LASTEXITCODE ("CMD valid invocation failed. " + ($launcherOutput -join ' '))
    $launcherItems = [System.IO.File]::ReadAllText($literalOutput) | ConvertFrom-Json
    Assert-Equal 3 $launcherItems.Count 'CMD did not publish the requested result.'
    Assert-Equal '192.0.2.0/24' $launcherItems[2].ip 'CMD result has an unexpected final CIDR.'
    $launcherBytes = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($literalOutput))

    [System.IO.File]::WriteAllText($testInput, '[]')
    $launcherOutput = & $launcher -InputPath $testInput -OutputPath $literalOutput -Language en
    Assert-Equal 1 $LASTEXITCODE ("CMD did not propagate child failure. " + ($launcherOutput -join ' '))
    Assert-Equal $launcherBytes ([Convert]::ToBase64String([System.IO.File]::ReadAllBytes($literalOutput))) 'CMD failure changed prior bytes.'
    Assert-NoTempFiles

    Write-Host 'All tests passed.' -ForegroundColor Green
}
finally {
    Pop-Location
    if (Test-Path -LiteralPath $tempDirectory) {
        Remove-Item -LiteralPath $tempDirectory -Recurse -Force
    }
}
