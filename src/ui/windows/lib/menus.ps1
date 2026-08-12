function Show-MainMenu
{
    $choice = gum choose `
        (Get-UiText 'MainConvertUrl') `
        (Get-UiText 'MainConvertFile') `
        (Get-UiText 'MainLanguage') `
        (Get-UiText 'MainExit')

    if ($choice -eq (Get-UiText 'MainConvertUrl'))
    {
        return 'Url'
    }

    if ($choice -eq (Get-UiText 'MainConvertFile'))
    {
        return 'File'
    }

    if ($choice -eq (Get-UiText 'MainLanguage'))
    {
        return 'Language'
    }

    return 'Exit'
}

function Show-SuccessMenu
{
    param(
        [Parameter(Mandatory)]
        [string]$OutputDirectory
    )

    while ($true)
    {
        $choice = gum choose `
            --header (Get-UiText 'WhatNext') `
            (Get-UiText 'OpenOutputDirectory') `
            (Get-UiText 'ConvertAnother') `
            (Get-UiText 'MainExit')

        if ($choice -eq (Get-UiText 'OpenOutputDirectory'))
        {
            Start-Process explorer.exe -ArgumentList $OutputDirectory
            continue
        }

        if ($choice -eq (Get-UiText 'ConvertAnother'))
        {
            return 'MainMenu'
        }

        return 'Exit'
    }
}

function Show-ErrorMenu
{
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Url', 'File')]
        [string]$Mode
    )

    while ($true)
    {
        $choice = gum choose `
            --header (Get-UiText 'WhatNext') `
            (Get-UiText 'ChangeParameters') `
            (Get-UiText 'MainMenu') `
            (Get-UiText 'MainExit')

        if ($choice -eq (Get-UiText 'MainMenu'))
        {
            return 'MainMenu'
        }

        if ($choice -eq (Get-UiText 'MainExit'))
        {
            return 'Exit'
        }

        $sourceAction = if ($Mode -eq 'Url') {
            Get-UiText 'EditUrl'
        } else {
            Get-UiText 'EditInputFile'
        }

        $parameterChoice = gum choose `
            --header (Get-UiText 'WhatChange') `
            $sourceAction `
            (Get-UiText 'ChangeOutput') `
            (Get-UiText 'Back')

        if ($parameterChoice -eq $sourceAction)
        {
            return 'EditSource'
        }

        if ($parameterChoice -eq (Get-UiText 'ChangeOutput'))
        {
            return 'ChangeOutput'
        }
    }
}
