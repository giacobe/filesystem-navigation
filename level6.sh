#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"
fresh_case
hex=$(derive_hex metadata)
size=$(range_from_byte "$(hex_byte "$hex" 0)" 300 700)
stem="$(theme_field item)-$(derive_hex target-name | cut -c 1-6)"
answer=$stem
mkdir -p "$CASE_DIR/candidates"
make_sized() { awk -v n="$2" 'BEGIN { for (i=0;i<n;i++) printf "M" }' > "$1"; }
make_sized "$CASE_DIR/candidates/$stem.dat" "$size"
make_sized "$CASE_DIR/candidates/same-size.dat" "$size"
make_sized "$CASE_DIR/candidates/same-mode.dat" "$((size + 7))"
make_sized "$CASE_DIR/candidates/ordinary.dat" "$((size - 11))"
printf 'Find the regular file in data/candidates with mode 0640 and exact size %s bytes. Report its filename without .dat.\n' "$size" > "$CASE_DIR/TASK.txt"
write_readme "Use find with exact permission and byte-size predicates to compare the candidates against data/TASK.txt. Both the mode and exact byte size matter.
Answer format: the lowercase filename stem only; omit .dat."
record_answer "$answer"
finish_level
chmod 600 "$CASE_DIR/candidates/same-size.dat"
chmod 640 "$CASE_DIR/candidates/$stem.dat" "$CASE_DIR/candidates/same-mode.dat"
chmod 644 "$CASE_DIR/candidates/ordinary.dat"
