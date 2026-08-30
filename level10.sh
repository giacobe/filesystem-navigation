#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"
fresh_case
answer=$(answer_token 16)
project="project-$(derive_hex project | cut -c 1-5)"
file=".$(theme_field item)-$(derive_hex final-name | cut -c 1-5).dat"
mkdir -p "$CASE_DIR/active/$project/.vault" "$CASE_DIR/recovery" "$CASE_DIR/aliases" "$CASE_DIR/archive/old/.vault"
target="$CASE_DIR/active/$project/.vault/$file"
printf '%s\n' "$answer" > "$target"
ln "$target" "$CASE_DIR/recovery/$file"
ln -s "../active/$project/.vault/$file" "$CASE_DIR/aliases/current"
printf 'same visible content, separate inode\n' > "$CASE_DIR/archive/old/.vault/$file"
printf 'unrelated hidden record\n' > "$CASE_DIR/active/$project/.vault/.decoy.dat"
ln -s "../archive/old/.vault/$file" "$CASE_DIR/aliases/archive"
printf 'PROJECT=%s\nALIAS=aliases/current\nRECOVERY=recovery/%s\nREQUIRED_MODE=0640\nREQUIRED_LINK_COUNT=2\n' "$project" "$file" > "$CASE_DIR/TASK.txt"
write_readme "Investigate data using TASK.txt. Resolve the stated symbolic alias, confirm its destination is hidden beneath the active project, verify mode 0640, and prove it shares an inode with the recovery name. Read the final artifact only after all clues agree.
Answer format: exactly 16 Base64url characters. Case matters."
finish_level
chmod 640 "$target"
