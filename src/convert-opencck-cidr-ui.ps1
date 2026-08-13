$ErrorActionPreference = 'Stop'

$uiPath = Join-Path `
    $PSScriptRoot `
    'ui\windows\main.ps1'

& $uiPath
