#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"
fresh_case
answer=$(answer_token 12)
root=$(theme_field root)
item=$(theme_field item)
folder=$(pick_word layout atlas beacon cedar delta ember fjord grove harbor iris juniper)
mkdir -p "$CASE_DIR/$root/work/current" "$CASE_DIR/$root/archive/$folder"
printf '%s\n' "$answer" > "$CASE_DIR/$root/archive/$folder/$item.txt"
printf 'not the requested record\n' > "$CASE_DIR/$root/work/$item.txt"
printf 'Begin in data/%s/work/current. Without returning to your home directory, use a relative path that goes up twice, then enters archive/%s and reads %s.txt.\n' "$root" "$folder" "$item" > "$CASE_DIR/TASK.txt"
write_readme "Read data/TASK.txt, change into its stated starting directory, and reach the answer using a relative path with .. components.
Answer format: exactly 12 Base64url characters. Case matters."
record_answer "$answer"
finish_level
