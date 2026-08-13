trim_value() {
    printf '%s' "$1" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//'
}

read_absolute_directory() {
    while true; do
        if ! directory=$(gum input \
            --placeholder "$(ui_text DirectoryPlaceholder)"); then
            return 1
        fi

        directory=$(trim_value "$directory")

        if [ -z "$directory" ]; then
            printf '\n%s\n' "$(ui_text DirectoryEmpty)"
            continue
        fi

        case "$directory" in
            /*) ;;
            *)
                printf '\n%s\n' "$(ui_text DirectoryAbsolute)"
                continue
                ;;
        esac

        INPUT_VALUE=$directory
        return 0
    done
}

select_output_directory() {
    if ! choice=$(gum choose \
        --header "$(ui_text OutputQuestion)" \
        "$(ui_text OutputDefault)" \
        "$(ui_text OutputAnother)"); then
        return 1
    fi

    if [ "$choice" = "$(ui_text OutputDefault)" ]; then
        OUTPUT_DIRECTORY=$(pwd -P)
        return 0
    fi

    if ! read_absolute_directory; then
        return 1
    fi

    OUTPUT_DIRECTORY=$INPUT_VALUE
}

read_source_value() {
    mode=$1
    current_value=${2:-}

    if [ "$mode" = "Url" ]; then
        placeholder=$(ui_text UrlPlaceholder)
    else
        placeholder=$(ui_text FilePlaceholder)
    fi

    if [ -z "$current_value" ]; then
        if ! value=$(gum input \
            --placeholder "$placeholder"); then
            return 1
        fi
    else
        if ! value=$(gum input \
            --value "$current_value" \
            --placeholder "$placeholder"); then
            return 1
        fi
    fi

    INPUT_VALUE=$value
}
