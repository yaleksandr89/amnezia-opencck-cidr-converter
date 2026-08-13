function Invoke-ConversionFlow
{
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Url', 'File')]
        [string]$Mode
    )

    Write-Host ""

    $source = Read-SourceValue -Mode $Mode

    :outputStep while ($true)
    {
        $outputDirectory = Select-OutputDirectory

        $outputPath = Join-Path `
            $outputDirectory `
            'amnezia-opencck-cidr.json'

        $sourceLabel = if ($Mode -eq 'Url') {
            Get-UiText 'SourceUrl'
        } else {
            Get-UiText 'SourceFile'
        }

        $summary = @(
            $sourceLabel
            $source
            ''
            (Get-UiText 'Output')
            $outputPath
        ) -join [Environment]::NewLine

        Write-Host ""
        Write-Host $summary

        $confirmation = gum choose `
            --header (Get-UiText 'CheckParameters') `
            (Get-UiText 'Run') `
            (Get-UiText 'Back') `
            (Get-UiText 'Cancel')

        if ($confirmation -eq (Get-UiText 'Back'))
        {
            continue outputStep
        }

        if ($confirmation -eq (Get-UiText 'Cancel'))
        {
            Write-Host ""
            Write-Host (Get-UiText 'Cancelled')

            return 'MainMenu'
        }

        :conversionAttempt while ($true)
        {
            $language = Get-UiLanguage

            if ($Mode -eq 'Url')
            {
                $result = & $ConverterPath `
                -SourceUrl $source `
                -OutputPath $outputPath `
                -Language $language `
                -PassThru `
                3>$null `
                6>$null
            }
            else
            {
                $result = & $ConverterPath `
                -InputPath $source `
                -OutputPath $outputPath `
                -Language $language `
                -PassThru `
                3>$null `
                6>$null
            }

            Write-Host ""

            if ($result.Success)
            {
                Write-Host (Get-UiText 'Success') -ForegroundColor Green
                Write-Host ""
                Write-Host "$(Get-UiText 'Routes'): $($result.RouteCount)"
                Write-Host "$(Get-UiText 'File'): $($result.OutputPath)"
                Write-Host ""

                return Show-SuccessMenu `
                    -OutputDirectory $outputDirectory
            }

            Write-Host (Get-UiText 'Failed') -ForegroundColor Red
            Write-Host ""
            Write-Host $result.ErrorMessage
            Write-Host ""

            $errorAction = Show-ErrorMenu -Mode $Mode

            switch ($errorAction)
            {
                'EditSource' {
                    $source = Read-SourceValue `
                        -Mode $Mode `
                        -CurrentValue $source

                    continue conversionAttempt
                }

                'ChangeOutput' {
                    continue outputStep
                }

                'MainMenu' {
                    return 'MainMenu'
                }

                'Exit' {
                    return 'Exit'
                }
            }
        }
    }
}
