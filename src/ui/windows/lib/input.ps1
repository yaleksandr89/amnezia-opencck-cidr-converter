function Read-AbsoluteDirectory
{
    while ($true)
    {
        $directory = gum input `
            --placeholder (Get-UiText 'DirectoryPlaceholder')

        $directory = $directory.Trim()

        if ([string]::IsNullOrWhiteSpace($directory))
        {
            Write-Host ""
            Write-Host (Get-UiText 'DirectoryEmpty') -ForegroundColor Yellow
            continue
        }

        if (-not [System.IO.Path]::IsPathRooted($directory))
        {
            Write-Host ""
            Write-Host (Get-UiText 'DirectoryAbsolute') -ForegroundColor Yellow
            continue
        }

        return $directory
    }
}

function Select-OutputDirectory
{
    $choice = gum choose `
        --header (Get-UiText 'OutputQuestion') `
        (Get-UiText 'OutputDefault') `
        (Get-UiText 'OutputAnother')

    if ($choice -eq (Get-UiText 'OutputDefault'))
    {
        return (Get-Location).ProviderPath
    }

    return Read-AbsoluteDirectory
}

function Read-SourceValue
{
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Url', 'File')]
        [string]$Mode,

        [Parameter()]
        [string]$CurrentValue
    )

    $placeholder = if ($Mode -eq 'Url') {
        Get-UiText 'UrlPlaceholder'
    } else {
        Get-UiText 'FilePlaceholder'
    }

    if ([string]::IsNullOrWhiteSpace($CurrentValue))
    {
        return gum input `
            --placeholder $placeholder
    }

    return gum input `
        --value $CurrentValue `
        --placeholder $placeholder
}
