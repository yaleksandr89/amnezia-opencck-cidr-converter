$ErrorActionPreference = 'Stop'

$utf8 = [System.Text.UTF8Encoding]::new($false)

[Console]::InputEncoding = $utf8
[Console]::OutputEncoding = $utf8
$OutputEncoding = $utf8

:mainMenu while ($true)
{
    $action = gum choose `
        "Convert from OpenCCK URL" `
        "Convert local JSON" `
        "Change language" `
        "Exit"

    switch ($action)
    {
        "Convert from OpenCCK URL" {
            Write-Host ""

            $url = gum input `
            --placeholder "https://iplist.opencck.org/..."

            :outputStep while ($true)
            {
                $outputChoice = gum choose `
                --header "Where should the result be saved?" `
                "Use default path" `
                "Enter another directory"

                switch ($outputChoice)
                {
                    "Use default path" {
                        $outputDirectory = (Get-Location).ProviderPath
                    }

                    "Enter another directory" {
                        while ($true)
                        {
                            $outputDirectory = gum input `
                            --placeholder "C:\Test"

                            $outputDirectory = $outputDirectory.Trim()

                            if ( [string]::IsNullOrWhiteSpace($outputDirectory))
                            {
                                Write-Host ""
                                Write-Host "Directory cannot be empty." -ForegroundColor Yellow
                                continue
                            }

                            if (-not [System.IO.Path]::IsPathRooted($outputDirectory))
                            {
                                Write-Host ""
                                Write-Host "Please enter an absolute path, for example C:\Test" -ForegroundColor Yellow
                                continue
                            }

                            break
                        }
                    }
                }

                $outputPath = Join-Path `
                $outputDirectory `
                "amnezia-opencck-cidr.json"

                $summary = @(
                    "Source:"
                    $url
                    ""
                    "Output:"
                    $outputPath
                ) -join [Environment]::NewLine

                Write-Host ""
                Write-Host $summary

                $confirmation = gum choose `
                --header "Please check the parameters" `
                "Run" `
                "Back" `
                "Cancel"

                switch ($confirmation)
                {
                    "Run" {
                        $converterPath = Join-Path `
                        $PSScriptRoot `
                        "convert-opencck-cidr.ps1"

                        :conversionAttempt while ($true)
                        {
                            $result = & $converterPath `
                            -SourceUrl $url `
                            -OutputPath $outputPath `
                            -Language en `
                            -PassThru `
                            3> $null `
                            6> $null

                            Write-Host ""

                            if ($result.Success)
                            {
                                Write-Host "Conversion completed successfully" -ForegroundColor Green
                                Write-Host ""
                                Write-Host "Routes: $( $result.RouteCount )"
                                Write-Host "File: $( $result.OutputPath )"
                                Write-Host ""

                                :successMenu while ($true)
                                {
                                    $successAction = gum choose `
                                    --header "What next?" `
                                    "Open output directory" `
                                    "Convert another list" `
                                    "Exit"

                                    switch ($successAction)
                                    {
                                        "Open output directory" {
                                            Start-Process explorer.exe -ArgumentList $outputDirectory
                                            continue successMenu
                                        }

                                        "Convert another list" {
                                            continue mainMenu
                                        }

                                        "Exit" {
                                            return
                                        }
                                    }
                                }
                            }
                            else
                            {
                                Write-Host "Conversion failed" -ForegroundColor Red
                                Write-Host ""
                                Write-Host $result.ErrorMessage
                                Write-Host ""

                                :errorMenu while ($true)
                                {
                                    $errorAction = gum choose `
                                    --header "What next?" `
                                    "Change parameters" `
                                    "Main menu" `
                                    "Exit"

                                    switch ($errorAction)
                                    {
                                        "Change parameters" {
                                            $parameterAction = gum choose `
                                            --header "What do you want to change?" `
                                            "Edit URL" `
                                            "Change output directory" `
                                            "Back"

                                            switch ($parameterAction)
                                            {
                                                "Edit URL" {
                                                    $url = gum input `
                                                    --value $url `
                                                    --placeholder "https://iplist.opencck.org/..."

                                                    continue conversionAttempt
                                                }

                                                "Change output directory" {
                                                    continue outputStep
                                                }

                                                "Back" {
                                                    continue errorMenu
                                                }
                                            }
                                        }

                                        "Main menu" {
                                            continue mainMenu
                                        }

                                        "Exit" {
                                            return
                                        }
                                    }
                                }
                            }
                        }
                    }

                    "Back" {
                        continue outputStep
                    }

                    "Cancel" {
                        Write-Host ""
                        Write-Host "Cancelled."
                        continue mainMenu
                    }
                }
            }
        }

        "Convert local JSON" {
            Write-Host ""
            Write-Host "Local JSON mode selected"
        }

        "Change language" {
            Write-Host ""
            Write-Host "Language selection will be here"
        }

        "Exit" {
            Write-Host ""
            Write-Host "Bye!"
            return
        }
    }
}
