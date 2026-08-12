$ErrorActionPreference = 'Stop'

$utf8 = [System.Text.UTF8Encoding]::new($false)

[Console]::InputEncoding = $utf8
[Console]::OutputEncoding = $utf8
$OutputEncoding = $utf8

$libDirectory = Join-Path $PSScriptRoot 'lib'

. (Join-Path $libDirectory 'messages.ps1')
. (Join-Path $libDirectory 'input.ps1')
. (Join-Path $libDirectory 'menus.ps1')
. (Join-Path $libDirectory 'conversion.ps1')

$corePath = Join-Path `
    $PSScriptRoot `
    '..\..\convert-opencck-cidr.ps1'

$ConverterPath = (Resolve-Path -LiteralPath $corePath).ProviderPath

:mainMenu while ($true)
{
    $action = Show-MainMenu

    switch ($action)
    {
        'Url' {
            $nextAction = Invoke-ConversionFlow -Mode Url

            if ($nextAction -eq 'Exit')
            {
                return
            }
        }

        'File' {
            $nextAction = Invoke-ConversionFlow -Mode File

            if ($nextAction -eq 'Exit')
            {
                return
            }
        }

        'Language' {
            $language = Show-LanguageMenu

            if ($language -ne 'Back')
            {
                Set-UiLanguage -Language $language
            }

            continue mainMenu
        }

        'Exit' {
            Write-Host ""
            Write-Host (Get-UiText 'Bye')
            return
        }
    }
}
