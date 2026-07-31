#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"
fresh_case
answer=$(answer_token 12)
item=$(theme_field item)
hidden=$(pick_word hidden cache registry staging vault workshop)
mkdir -p "$CASE_DIR/.$hidden"
printf '%s\n' "$answer" > "$CASE_DIR/.$hidden/.$item-key"
printf 'shell preference\n' > "$CASE_DIR/.profile"
printf 'temporary data\n' > "$CASE_DIR/.cache-note"
printf 'ordinary record\n' > "$CASE_DIR/$item.txt"
write_readme "Hidden entries begin with a dot and ordinary ls output omits them. Find the hidden directory in data, then read the hidden file whose name ends in -key.
Answer format: exactly 12 Base64url characters. Case matters."
record_answer "$answer"
finish_level
