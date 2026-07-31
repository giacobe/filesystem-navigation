#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"
fresh_case
answer=$(answer_token 12)
hex=$(derive_hex size)
size=$(range_from_byte "$(hex_byte "$hex" 0)" 220 420)
mkdir -p "$CASE_DIR/search/active" "$CASE_DIR/search/archive" "$CASE_DIR/outside"
target="$CASE_DIR/search/active/$(theme_field item)-$(derive_hex target-name | cut -c 1-5).dat"
write_sized() {
    path=$1; bytes=$2; prefix=$3
    used=$((${#prefix} + 1))
    printf '%s\n' "$prefix" > "$path"
    awk -v n="$((bytes - used))" 'BEGIN { for (i=0;i<n;i++) printf "X" }' >> "$path"
}
write_sized "$target" "$size" "$answer"
write_sized "$CASE_DIR/search/archive/$(theme_field item)-old.dat" "$((size + 1))" decoy
write_sized "$CASE_DIR/search/active/unrelated.dat" "$size" decoy
write_sized "$CASE_DIR/outside/$(theme_field item)-copy.dat" "$size" decoy
mkdir "$CASE_DIR/search/active/$(theme_field item)-directory.dat"
printf 'Search only data/search for a regular file named %s-*.dat whose exact size is %s bytes. Read its first line.\n' "$(theme_field item)" "$size" > "$CASE_DIR/TASK.txt"
write_readme "Use find and the predicates in data/TASK.txt. Similar entries deliberately fail one condition.
Answer format: exactly 12 Base64url characters. Case matters."
record_answer "$answer"
finish_level
