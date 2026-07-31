#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"
fresh_case
first="$(theme_field item)-$(derive_hex first-name | cut -c 1-5).dat"
second="recovery-$(derive_hex second-name | cut -c 1-5).dat"
mkdir -p "$CASE_DIR/records" "$CASE_DIR/recovery"
printf 'shared underlying record\n' > "$CASE_DIR/records/$first"
ln "$CASE_DIR/records/$first" "$CASE_DIR/recovery/$second"
printf 'shared underlying record\n' > "$CASE_DIR/records/content-copy.dat"
printf 'independent record\n' > "$CASE_DIR/recovery/other.dat"
answer=$(printf '%s\n%s\n' "$first" "$second" | sort | awk 'NR==1 {a=$0} NR==2 {print a "|" $0}')
write_readme "Find the two regular filenames under data/records and data/recovery that share one inode. Duplicate content is not sufficient evidence. Report just their basenames in lexical order.
Answer format: name1|name2 including .dat, no spaces."
record_answer "$answer"
finish_level
