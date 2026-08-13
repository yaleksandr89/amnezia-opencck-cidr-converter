function Test-UiDependencies
{
    param(
        [Parameter(Mandatory)]
        [string]$CorePath
    )

    $hasErrors = $false

    $gumCommand = Get-Command `
        -Name 'gum' `
        -CommandType Application `
        -ErrorAction SilentlyContinue

    if ($null -eq $gumCommand)
    {
        Write-Host ""
        Write-Host (Get-UiText 'DependencyFailed') -ForegroundColor Red
        Write-Host ""
        Write-Host (Get-UiText 'GumMissing')
        Write-Host (Get-UiText 'GumMissingHint')
        $hasErrors = $true
    }

    if (-not (Test-Path -LiteralPath $CorePath -PathType Leaf))
    {
        if (-not $hasErrors)
        {
            Write-Host ""
            Write-Host (Get-UiText 'DependencyFailed') -ForegroundColor Red
            Write-Host ""
        }

        Write-Host (Get-UiText 'CoreMissing')
        Write-Host $CorePath
        $hasErrors = $true
    }

    return (-not $hasErrors)
}
