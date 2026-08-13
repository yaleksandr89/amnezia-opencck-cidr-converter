show_main_menu() {
    if ! choice=$(gum choose \
        "$(ui_text MainConvertUrl)" \
        "$(ui_text MainConvertFile)" \
        "$(ui_text MainLanguage)" \
        "$(ui_text MainExit)"); then
        MENU_ACTION="Exit"
        return
    fi

    if [ "$choice" = "$(ui_text MainConvertUrl)" ]; then
        MENU_ACTION="Url"
    elif [ "$choice" = "$(ui_text MainConvertFile)" ]; then
        MENU_ACTION="File"
    elif [ "$choice" = "$(ui_text MainLanguage)" ]; then
        MENU_ACTION="Language"
    else
        MENU_ACTION="Exit"
    fi
}

show_success_menu() {
    output_directory=$1

    while true; do
        if ! choice=$(gum choose \
            --header "$(ui_text WhatNext)" \
            "$(ui_text OpenOutputDirectory)" \
            "$(ui_text ConvertAnother)" \
            "$(ui_text MainExit)"); then
            MENU_ACTION="Exit"
            return
        fi

        if [ "$choice" = "$(ui_text OpenOutputDirectory)" ]; then
            if ! platform_open_directory "$output_directory"; then
                printf '\n%s\n' "$(ui_text OpenDirectoryUnavailable)"
            fi
            continue
        fi

        if [ "$choice" = "$(ui_text ConvertAnother)" ]; then
            MENU_ACTION="MainMenu"
        else
            MENU_ACTION="Exit"
        fi
        return
    done
}

show_error_menu() {
    mode=$1

    while true; do
        if ! choice=$(gum choose \
            --header "$(ui_text WhatNext)" \
            "$(ui_text ChangeParameters)" \
            "$(ui_text MainMenu)" \
            "$(ui_text MainExit)"); then
            MENU_ACTION="Exit"
            return
        fi

        if [ "$choice" = "$(ui_text MainMenu)" ]; then
            MENU_ACTION="MainMenu"
            return
        fi

        if [ "$choice" = "$(ui_text MainExit)" ]; then
            MENU_ACTION="Exit"
            return
        fi

        if [ "$mode" = "Url" ]; then
            source_action=$(ui_text EditUrl)
        else
            source_action=$(ui_text EditInputFile)
        fi

        if ! parameter_choice=$(gum choose \
            --header "$(ui_text WhatChange)" \
            "$source_action" \
            "$(ui_text ChangeOutput)" \
            "$(ui_text Back)"); then
            continue
        fi

        if [ "$parameter_choice" = "$source_action" ]; then
            MENU_ACTION="EditSource"
            return
        fi

        if [ "$parameter_choice" = "$(ui_text ChangeOutput)" ]; then
            MENU_ACTION="ChangeOutput"
            return
        fi
    done
}

show_language_menu() {
    if ! choice=$(gum choose \
        --header "$(ui_text ChooseLanguage)" \
        'English' \
        'Русский' \
        "$(ui_text Back)"); then
        MENU_ACTION="Back"
        return
    fi

    case "$choice" in
        English) MENU_ACTION="en" ;;
        Русский) MENU_ACTION="ru" ;;
        *) MENU_ACTION="Back" ;;
    esac
}
