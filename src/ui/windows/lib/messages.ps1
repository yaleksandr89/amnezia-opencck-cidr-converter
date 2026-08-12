$UiLanguage = 'en'

$UiMessages = @{
    en = @{
        MainConvertUrl       = 'Convert from OpenCCK URL'
        MainConvertFile      = 'Convert local JSON'
        MainLanguage         = 'Change language'
        MainExit             = 'Exit'

        UrlPlaceholder       = 'https://iplist.opencck.org/...'
        FilePlaceholder      = 'C:\path\opencck.json'
        DirectoryPlaceholder = 'C:\Test'

        OutputQuestion       = 'Where should the result be saved?'
        OutputDefault        = 'Use default path'
        OutputAnother        = 'Enter another directory'

        DirectoryEmpty       = 'Directory cannot be empty.'
        DirectoryAbsolute    = 'Please enter an absolute path, for example C:\Test'

        SourceUrl            = 'Source:'
        SourceFile           = 'Source file:'
        Output               = 'Output:'

        CheckParameters      = 'Please check the parameters'
        Run                  = 'Run'
        Back                 = 'Back'
        Cancel               = 'Cancel'
        Cancelled            = 'Cancelled.'

        Success              = 'Conversion completed successfully'
        Failed               = 'Conversion failed'
        Routes               = 'Routes'
        File                 = 'File'

        WhatNext             = 'What next?'
        OpenOutputDirectory  = 'Open output directory'
        ConvertAnother       = 'Convert another list'

        ChangeParameters     = 'Change parameters'
        MainMenu             = 'Main menu'
        WhatChange           = 'What do you want to change?'
        EditUrl              = 'Edit URL'
        EditInputFile        = 'Edit input file'
        ChangeOutput         = 'Change output directory'

        LanguageStub         = 'Language selection will be here'
        Bye                  = 'Bye!'
    }
}

function Get-UiText
{
    param(
        [Parameter(Mandatory)]
        [string]$Key
    )

    return $UiMessages[$UiLanguage][$Key]
}
