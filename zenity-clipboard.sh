#!/bin/bash
CACHE_DIR="./simple_cache"
if ! $CACHE_DIR; then
    CACHE_DIR="/home/{your_user}/simple_cache"
fi

echo $CACHE_DIR

files=("$CACHE_DIR"/*)
files=("${files[@]##*/}")

declare -a files_path

for file_path in "${files[@]}"; do
    files_path+=("$CACHE_DIR/$file_path")
done

for file_path in "${files_path[@]}"; do
    cat "$file_path"
    echo "################################ Clipboard by github/oh_math :) ################################"
done | zenity --text-info \
    --title="Multiple File Contents" \
    --width=800 \
    --height=600
