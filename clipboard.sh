#!/bin/bash

CACHE_DIR="./simple_cache"
current_dir=$(pwd)

if [ "$current_dir" = "home/{your_user}" ]; then
    CACHE_DIR="home/{your_user}/path-to-your-local-simple-cache"
fi

create_cache_dir() {
    mkdir -p "$CACHE_DIR"
}

insert_into_cache() {
    local key="$1"
    local value="$2"

    echo "$value" >>"$CACHE_DIR/$key"

    touch "$CACHE_DIR/$key"
}

clear_cache() {
    rm -vrf "$CACHE_DIR/*"
}

# -------------------------------------------------------------------------------------

NEWEST_FILE=$(find "$CACHE_DIR" -type f -printf '%T@ %p\n' | sort -rn | head -n 1 | cut -d' ' -f2-)

get_first_number() {
    local input_string="$1"

    cleaned_string=$(sed 's/[^0-9]*//g' <<<"$input_string")

    grep -oE '^[0-9]+' <<<"$cleaned_string"
}

get_clipboard_content() {
    xclip -selection clipboard -o
}
get_newest_file() {
    find "$CACHE_DIR" -type f -printf '%T@ %p\n' | sort -rn | head -n 1 | cut -d' ' -f2-
}
declare -a clipboard_history

curr_clip_equal_last() {
    local current_clipboard=$(get_clipboard_content)

    if ! [ -z "$NEWEST_FILE" ]; then
        content=$(cat "$NEWEST_FILE")

        if [ "$current_clipboard" = "$content" ]; then
            return 0
        else
            return 1
        fi
    fi

}

main() {
    local current_clipboard=$(get_clipboard_content)
    last_file_number=$(get_first_number "$NEWEST_FILE")
    ((last_file_number++))

    echo $last_file_number

    files_amount=$(ls -l $CACHE_DIR | grep ^- | wc -l)

    if [ ${files_amount} = 0 ]; then
        insert_into_cache "file1.txt" "$current_clipboard"
    fi

    if [ ${files_amount} -gt 10 ]; then
        rm $(find $CACHE_DIR -type f -printf '%T@ %p\n' | sort -n | head -n 1 | cut -d' ' -f2-)
    fi

    if ! curr_clip_equal_last; then

        insert_into_cache "file$last_file_number.txt" "$current_clipboard"

    fi
}

create_cache_dir
main
