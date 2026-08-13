platform_open_directory() {
    directory=$1
    kernel_release=$(uname -r 2>/dev/null || printf '')

    case "$kernel_release" in
        *microsoft*|*Microsoft*)
            if command -v explorer.exe >/dev/null 2>&1                 && command -v wslpath >/dev/null 2>&1; then
                explorer.exe "$(wslpath -w "$directory")" >/dev/null 2>&1 &
                return 0
            fi
            ;;
    esac

    if [ "$(uname -s 2>/dev/null || printf '')" = "Darwin" ]         && command -v open >/dev/null 2>&1; then
        open "$directory" >/dev/null 2>&1
        return $?
    fi

    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$directory" >/dev/null 2>&1
        return $?
    fi

    return 1
}
