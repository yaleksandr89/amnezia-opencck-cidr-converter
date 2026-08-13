UI_LANGUAGE="en"

ui_text() {
    case "$UI_LANGUAGE:$1" in
        en:MainConvertUrl) printf 'Convert from OpenCCK URL' ;;
        ru:MainConvertUrl) printf 'Конвертировать из ссылки OpenCCK' ;;
        en:MainConvertFile) printf 'Convert local JSON' ;;
        ru:MainConvertFile) printf 'Конвертировать локальный JSON' ;;
        en:MainLanguage) printf 'Change language' ;;
        ru:MainLanguage) printf 'Сменить язык' ;;
        en:MainExit) printf 'Exit' ;;
        ru:MainExit) printf 'Выход' ;;

        en:ChooseLanguage) printf 'Choose language' ;;
        ru:ChooseLanguage) printf 'Выберите язык' ;;

        en:UrlPlaceholder|ru:UrlPlaceholder) printf 'https://iplist.opencck.org/...' ;;
        en:FilePlaceholder) printf '/path/opencck.json' ;;
        ru:FilePlaceholder) printf '/путь/opencck.json' ;;
        en:DirectoryPlaceholder|ru:DirectoryPlaceholder) printf '/tmp' ;;

        en:OutputQuestion) printf 'Where should the result be saved?' ;;
        ru:OutputQuestion) printf 'Куда сохранить результат?' ;;
        en:OutputDefault) printf 'Use current directory' ;;
        ru:OutputDefault) printf 'Использовать текущую папку' ;;
        en:OutputAnother) printf 'Enter another directory' ;;
        ru:OutputAnother) printf 'Указать другую папку' ;;

        en:DirectoryEmpty) printf 'Directory cannot be empty.' ;;
        ru:DirectoryEmpty) printf 'Путь к папке не может быть пустым.' ;;
        en:DirectoryAbsolute) printf 'Please enter an absolute path, for example /tmp' ;;
        ru:DirectoryAbsolute) printf 'Укажите абсолютный путь, например /tmp' ;;

        en:SourceUrl) printf 'Source:' ;;
        ru:SourceUrl) printf 'Источник:' ;;
        en:SourceFile) printf 'Source file:' ;;
        ru:SourceFile) printf 'Исходный файл:' ;;
        en:Output) printf 'Output:' ;;
        ru:Output) printf 'Результат:' ;;

        en:CheckParameters) printf 'Please check the parameters' ;;
        ru:CheckParameters) printf 'Проверьте параметры' ;;
        en:Run) printf 'Run' ;;
        ru:Run) printf 'Запустить' ;;
        en:Back) printf 'Back' ;;
        ru:Back) printf 'Назад' ;;
        en:Cancel) printf 'Cancel' ;;
        ru:Cancel) printf 'Отмена' ;;
        en:Cancelled) printf 'Cancelled.' ;;
        ru:Cancelled) printf 'Отменено.' ;;

        en:Success) printf 'Conversion completed successfully' ;;
        ru:Success) printf 'Конвертация успешно завершена' ;;
        en:Failed) printf 'Conversion failed' ;;
        ru:Failed) printf 'Ошибка конвертации' ;;
        en:Routes) printf 'Routes' ;;
        ru:Routes) printf 'Маршрутов' ;;
        en:File) printf 'File' ;;
        ru:File) printf 'Файл' ;;

        en:WhatNext) printf 'What next?' ;;
        ru:WhatNext) printf 'Что дальше?' ;;
        en:OpenOutputDirectory) printf 'Open output directory' ;;
        ru:OpenOutputDirectory) printf 'Открыть папку с результатом' ;;
        en:OpenDirectoryUnavailable) printf 'No supported command for opening directories was found.' ;;
        ru:OpenDirectoryUnavailable) printf 'Не найдена команда для открытия папки.' ;;
        en:ConvertAnother) printf 'Convert another list' ;;
        ru:ConvertAnother) printf 'Конвертировать другой список' ;;

        en:ChangeParameters) printf 'Change parameters' ;;
        ru:ChangeParameters) printf 'Изменить параметры' ;;
        en:MainMenu) printf 'Main menu' ;;
        ru:MainMenu) printf 'Главное меню' ;;
        en:WhatChange) printf 'What do you want to change?' ;;
        ru:WhatChange) printf 'Что изменить?' ;;
        en:EditUrl) printf 'Edit URL' ;;
        ru:EditUrl) printf 'Изменить ссылку' ;;
        en:EditInputFile) printf 'Edit input file' ;;
        ru:EditInputFile) printf 'Изменить исходный файл' ;;
        en:ChangeOutput) printf 'Change output directory' ;;
        ru:ChangeOutput) printf 'Изменить папку сохранения' ;;

        en:DependencyFailed) printf 'Cannot start TUI.' ;;
        ru:DependencyFailed) printf 'Не удалось запустить TUI.' ;;
        en:GumMissing) printf 'gum was not found in PATH.' ;;
        ru:GumMissing) printf 'gum не найден в PATH.' ;;
        en:GumMissingHint) printf 'Install gum or add it to PATH, then run the TUI again.' ;;
        ru:GumMissingHint) printf 'Установите gum или добавьте его в PATH, затем запустите TUI снова.' ;;
        en:CoreMissing) printf 'Core converter was not found:' ;;
        ru:CoreMissing) printf 'Не найден основной конвертер:' ;;

        en:InvalidMachineResult) printf 'Converter returned an invalid machine-readable result.' ;;
        ru:InvalidMachineResult) printf 'Конвертер вернул некорректный машинный результат.' ;;

        en:Bye) printf 'Bye!' ;;
        ru:Bye) printf 'До свидания!' ;;
        *) printf 'Unknown UI text key: %s' "$1" ;;
    esac
}

set_ui_language() {
    case "$1" in
        en|ru) UI_LANGUAGE=$1 ;;
    esac
}

get_ui_language() {
    printf '%s' "$UI_LANGUAGE"
}
