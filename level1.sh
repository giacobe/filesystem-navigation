#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"
fresh_case
answer=$(answer_token 12)
root=$(theme_field root)
place=$(theme_field place)
mkdir -p "$CASE_DIR/$root/$place"
printf '%s\n' "$answer" > "$CASE_DIR/$root/$place/coordinates.txt"
printf 'training record\n' > "$CASE_DIR/$root/$place/notes.txt"
write_readme "Use this absolute path to read the answer file:
/srv/filesystem-navigation/cases/level1/$root/$place/coordinates.txt
Answer format: exactly 12 Base64url characters. Case matters."
record_answer "$answer"
finish_level
