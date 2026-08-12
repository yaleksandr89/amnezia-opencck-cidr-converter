$script:UiLanguage = 'en'

$UiMessages = @{
    en = @{
        MainConvertUrl       = 'Convert from OpenCCK URL'
        MainConvertFile      = 'Convert local JSON'
        MainLanguage         = 'Change language'
        MainExit             = 'Exit'

        ChooseLanguage       = 'Choose language'

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

        DependencyFailed    = 'Cannot start TUI.'
        GumMissing          = 'gum was not found in PATH.'
        GumMissingHint      = 'Install gum or add gum.exe to PATH, then run the TUI again.'
        CoreMissing         = 'Core converter was not found:'

        Bye                  = 'Bye!'
    }

    ru = @{
        MainConvertUrl       = 'Конвертировать из ссылки OpenCCK'
        MainConvertFile      = 'Конвертировать локальный JSON'
        MainLanguage         = 'Сменить язык'
        MainExit             = 'Выход'

        ChooseLanguage       = 'Выберите язык'

        UrlPlaceholder       = 'https://iplist.opencck.org/...'
        FilePlaceholder      = 'C:\путь\opencck.json'
        DirectoryPlaceholder = 'C:\Test'

        OutputQuestion       = 'Куда сохранить результат?'
        OutputDefault        = 'Использовать путь по умолчанию'
        OutputAnother        = 'Указать другую папку'

        DirectoryEmpty       = 'Путь к папке не может быть пустым.'
        DirectoryAbsolute    = 'Укажите абсолютный путь, например C:\Test'

        SourceUrl            = 'Источник:'
        SourceFile           = 'Исходный файл:'
        Output               = 'Результат:'

        CheckParameters      = 'Проверьте параметры'
        Run                  = 'Запустить'
        Back                 = 'Назад'
        Cancel               = 'Отмена'
        Cancelled            = 'Отменено.'

        Success              = 'Конвертация успешно завершена'
        Failed               = 'Ошибка конвертации'
        Routes               = 'Маршрутов'
        File                 = 'Файл'

        WhatNext             = 'Что дальше?'
        OpenOutputDirectory  = 'Открыть папку с результатом'
        ConvertAnother       = 'Конвертировать другой список'

        ChangeParameters     = 'Изменить параметры'
        MainMenu             = 'Главное меню'
        WhatChange           = 'Что изменить?'
        EditUrl              = 'Изменить ссылку'
        EditInputFile        = 'Изменить исходный файл'
        ChangeOutput         = 'Изменить папку сохранения'

        DependencyFailed    = 'Не удалось запустить TUI.'
        GumMissing          = 'gum не найден в PATH.'
        GumMissingHint      = 'Установите gum или добавьте gum.exe в PATH, затем запустите TUI снова.'
        CoreMissing         = 'Не найден основной конвертер:'

        Bye                  = 'До свидания!'
    }
}

function Get-UiText
{
    param(
        [Parameter(Mandatory)]
        [string]$Key
    )

    return $UiMessages[$script:UiLanguage][$Key]
}

function Get-UiLanguage
{
    return $script:UiLanguage
}

function Set-UiLanguage
{
    param(
        [Parameter(Mandatory)]
        [ValidateSet('en', 'ru')]
        [string]$Language
    )

    $script:UiLanguage = $Language
}
