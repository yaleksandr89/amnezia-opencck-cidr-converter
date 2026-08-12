$ErrorActionPreference = 'Stop'

$gumVersion = '0.17.0'
$gumArchiveName = "gum_${gumVersion}_Windows_x86_64.zip"
$gumUrl = "https://github.com/charmbracelet/gum/releases/download/v${gumVersion}/${gumArchiveName}"
$gumSha256 = 'b2be80531c6babc8d4e0e6ca95773d58118a2e1582ae006aace08dbc55503072'

$cacheDirectory = Join-Path `
    $PSScriptRoot `
    'cache'

$gumArchivePath = Join-Path `
    $cacheDirectory `
    $gumArchiveName

$repositoryRoot = (
Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')
).ProviderPath

$distDirectory = Join-Path $repositoryRoot 'dist'

$packageName = 'amnezia-opencck-cidr-converter_windows_x64'
$packageDirectory = Join-Path $distDirectory $packageName
$runtimeDirectory = Join-Path $packageDirectory 'runtime'
$runtimeSourceDirectory = Join-Path $runtimeDirectory 'src'

$archivePath = Join-Path `
    $distDirectory `
    "${packageName}.zip"

$tempDirectory = Join-Path `
    ([System.IO.Path]::GetTempPath()) `
    ("amnezia-opencck-build-" + [guid]::NewGuid().ToString('N'))

try
{
    if (Test-Path -LiteralPath $packageDirectory)
    {
        Remove-Item `
            -LiteralPath $packageDirectory `
            -Recurse `
            -Force
    }

    if (Test-Path -LiteralPath $archivePath)
    {
        Remove-Item `
            -LiteralPath $archivePath `
            -Force
    }

    New-Item `
        -ItemType Directory `
        -Path $runtimeSourceDirectory `
        -Force | Out-Null

    New-Item `
        -ItemType Directory `
        -Path $tempDirectory `
        -Force | Out-Null

    Write-Host 'Copying runtime...'

    Copy-Item `
        -LiteralPath (Join-Path $repositoryRoot 'src\convert-opencck-cidr.ps1') `
        -Destination $runtimeSourceDirectory

    Copy-Item `
        -LiteralPath (Join-Path $repositoryRoot 'src\convert-opencck-cidr-ui.ps1') `
        -Destination $runtimeSourceDirectory

    Copy-Item `
        -LiteralPath (Join-Path $repositoryRoot 'src\ui') `
        -Destination $runtimeSourceDirectory `
        -Recurse

    Write-Host 'Preparing PowerShell runtime encoding...'

    $utf8WithBom = [System.Text.UTF8Encoding]::new($true)

    Get-ChildItem `
    -LiteralPath $runtimeSourceDirectory `
    -Filter '*.ps1' `
    -File `
    -Recurse |
        ForEach-Object {
            $content = [System.IO.File]::ReadAllText($_.FullName)

            [System.IO.File]::WriteAllText(
                $_.FullName,
                $content,
                $utf8WithBom
            )
        }

    Copy-Item `
        -LiteralPath (Join-Path $repositoryRoot 'LICENSE') `
        -Destination $packageDirectory

    $thirdPartyDirectory = Join-Path `
        $packageDirectory `
        'THIRD_PARTY_LICENSES'

    New-Item `
        -ItemType Directory `
        -Path $thirdPartyDirectory `
        -Force | Out-Null

    Copy-Item `
        -LiteralPath (Join-Path $PSScriptRoot 'third-party\GUM-LICENSE.txt') `
        -Destination $thirdPartyDirectory

    New-Item `
    -ItemType Directory `
    -Path $cacheDirectory `
    -Force | Out-Null

    $gumArchiveIsValid = $false

    if (Test-Path -LiteralPath $gumArchivePath -PathType Leaf)
    {
        Write-Host "Checking cached gum $gumVersion..."

        $cachedGumSha256 = (
        Get-FileHash `
            -LiteralPath $gumArchivePath `
            -Algorithm SHA256
        ).Hash.ToLowerInvariant()

        if ($cachedGumSha256 -eq $gumSha256)
        {
            Write-Host 'Using cached gum archive.'
            $gumArchiveIsValid = $true
        }
        else
        {
            Write-Host 'Cached gum archive is invalid. Downloading again.' -ForegroundColor Yellow

            Remove-Item `
            -LiteralPath $gumArchivePath `
            -Force
        }
    }

    if (-not $gumArchiveIsValid)
    {
        Write-Host "Downloading gum $gumVersion..."

        $downloadPath = Join-Path `
        $tempDirectory `
        $gumArchiveName

        $curlPath = Join-Path `
        $env:WINDIR `
        'System32\curl.exe'

        if (-not (Test-Path -LiteralPath $curlPath -PathType Leaf))
        {
            throw 'curl.exe was not found.'
        }

        & $curlPath `
        '-L' `
        '--fail' `
        '--retry' '3' `
        '--retry-all-errors' `
        '--retry-delay' '2' `
        '--output' $downloadPath `
        $gumUrl

        if ($LASTEXITCODE -ne 0)
        {
            throw "Failed to download gum. curl exit code: $LASTEXITCODE"
        }

        Write-Host 'Checking downloaded gum SHA-256...'

        $downloadedGumSha256 = (
        Get-FileHash `
            -LiteralPath $downloadPath `
            -Algorithm SHA256
        ).Hash.ToLowerInvariant()

        if ($downloadedGumSha256 -ne $gumSha256)
        {
            throw "gum SHA-256 mismatch. Expected: $gumSha256, actual: $downloadedGumSha256"
        }

        Move-Item `
        -LiteralPath $downloadPath `
        -Destination $gumArchivePath `
        -Force
    }

    $gumExtractDirectory = Join-Path `
        $tempDirectory `
        'gum'

    Expand-Archive `
        -LiteralPath $gumArchivePath `
        -DestinationPath $gumExtractDirectory

    $gumExecutable = Get-ChildItem `
        -LiteralPath $gumExtractDirectory `
        -Filter 'gum.exe' `
        -File `
        -Recurse |
        Select-Object -First 1

    if ($null -eq $gumExecutable)
    {
        throw 'gum.exe was not found in the downloaded archive.'
    }

    Copy-Item `
        -LiteralPath $gumExecutable.FullName `
        -Destination (Join-Path $runtimeDirectory 'gum.exe')

    Write-Host 'Building Windows launcher...'

    $compilerCandidates = @(
        (Join-Path $env:WINDIR 'Microsoft.NET\Framework64\v4.0.30319\csc.exe')
        (Join-Path $env:WINDIR 'Microsoft.NET\Framework\v4.0.30319\csc.exe')
    )

    $compilerPath = $compilerCandidates |
        Where-Object { Test-Path -LiteralPath $_ } |
        Select-Object -First 1

    if ([string]::IsNullOrWhiteSpace($compilerPath))
    {
        throw 'C# compiler csc.exe was not found.'
    }

    $launcherSource = Join-Path `
        $PSScriptRoot `
        'launcher\Program.cs'

    $launcherIcon = Join-Path `
        $PSScriptRoot `
        'launcher\app.ico'

    $launcherExecutable = Join-Path `
        $packageDirectory `
        'amnezia-opencck-cidr-converter.exe'

    & $compilerPath `
        '/nologo' `
        '/target:exe' `
        "/win32icon:$launcherIcon" `
        "/out:$launcherExecutable" `
        $launcherSource

    if ($LASTEXITCODE -ne 0)
    {
        throw "Launcher compilation failed with exit code $LASTEXITCODE."
    }

    Write-Host 'Creating release archive...'

    Compress-Archive `
        -LiteralPath $packageDirectory `
        -DestinationPath $archivePath

    Write-Host ''
    Write-Host 'Windows package created successfully.' -ForegroundColor Green
    Write-Host "Directory: $packageDirectory"
    Write-Host "Archive: $archivePath"
}
finally
{
    if (Test-Path -LiteralPath $tempDirectory)
    {
        Remove-Item `
            -LiteralPath $tempDirectory `
            -Recurse `
            -Force
    }
}
