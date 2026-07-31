#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"
fresh_case
root=$(theme_field root)
item=$(theme_field item)
folder=$(pick_word target active verified primary stable)
mkdir -p "$CASE_DIR/$root/$folder" "$CASE_DIR/links/nested"
target_rel="$root/$folder/$item.dat"
printf 'canonical destination\n' > "$CASE_DIR/$target_rel"
ln -s "../../$target_rel" "$CASE_DIR/links/nested/entry"
ln -s "nested/entry" "$CASE_DIR/links/current"
ln -s "missing/record" "$CASE_DIR/links/broken"
ln -s loop-b "$CASE_DIR/links/loop-a"
ln -s loop-a "$CASE_DIR/links/loop-b"
ln -s "/srv/filesystem-navigation/cases/level9/$target_rel" "$CASE_DIR/links/absolute-copy"
answer="/srv/filesystem-navigation/cases/level9/$target_rel"
write_readme "Resolve data/links/current through its relative symbolic-link chain. Ignore the broken link and loop. Report the normalized absolute path of the regular destination in the deployed lab.
Answer format: one absolute path beginning /srv/filesystem-navigation/cases/level9/ with no trailing slash."
record_answer "$answer"
finish_level
