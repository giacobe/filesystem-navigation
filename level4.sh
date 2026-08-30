#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"
fresh_case
branch=$(pick_word branch north south east west upper lower)
section=$(pick_word section amber cobalt jade silver violet)
item=$(theme_field item)
leaf="$(derive_hex leaf | cut -c 1-6)-$item.txt"
for b in north south east west upper lower; do
    for s in amber cobalt jade silver violet; do
        mkdir -p "$CASE_DIR/$b/$s"
        printf 'index for %s/%s\n' "$b" "$s" > "$CASE_DIR/$b/$s/index.txt"
    done
done
printf 'This is the uniquely marked destination.\n' > "$CASE_DIR/$branch/$section/$leaf"
answer="$branch/$section/$leaf"
printf 'BRANCH=%s\nSECTION=%s\nMARKER=uniquely marked destination\n' "$branch" "$section" > "$CASE_DIR/TASK.txt"
write_readme "Explore the directory tree under data. TASK.txt gives the branch, section, and content marker. Report the path of the matching file relative to data.
Answer format: branch/section/filename with exact lowercase spelling and no leading ./"
finish_level
