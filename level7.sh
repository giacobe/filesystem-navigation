#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"
fresh_case
answer=$(answer_token 14)
item=$(theme_field item)
folder=$(pick_word destination archive current secure verified)
mkdir -p "$CASE_DIR/links" "$CASE_DIR/store/$folder"
printf '%s\n' "$answer" > "$CASE_DIR/store/$folder/$item-key.txt"
printf '../store/%s/%s-key.txt\n' "$folder" "$item" > "$CASE_DIR/links/path-note.txt"
printf 'decoy\n' > "$CASE_DIR/store/$folder/old-key.txt"
mkdir -p "$CASE_DIR/store/reference" "$CASE_DIR/links/archive"
write_numbered_files "$CASE_DIR/store/reference" "$(theme_field item)-" "-key.txt" 28 "stored decoy"
i=1
while [ "$i" -le 16 ]; do
    ln -s "../../store/reference/$(theme_field item)-$i-key.txt" "$CASE_DIR/links/archive/key-$i"
    i=$((i + 1))
done
ln -s "../store/$folder/$item-key.txt" "$CASE_DIR/links/current-key"
write_readme "In data/links, distinguish the symbolic link current-key from the regular file that merely contains path text. Inspect the link target, follow it, and read the answer.
Answer format: exactly 14 Base64url characters. Case matters."
finish_level
