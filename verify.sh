#!/bin/sh
set -eu

ANSWER_DIR=${ANSWER_DIR:-/var/lib/filesystem-navigation/answers}
CASE_ROOT=${CASE_ROOT:-/srv/filesystem-navigation/cases}
failures=0

check() {
    level=$1
    actual=$2
    expected=$(sed -n '1p' "$ANSWER_DIR/level$level")
    if [ "$actual" = "$expected" ]; then
        echo "level$level: PASS"
    else
        echo "level$level: FAIL" >&2
        echo "  expected: $expected" >&2
        echo "  solver:   $actual" >&2
        failures=$((failures + 1))
    fi
}

# Level 1: locate and read the file named by the supplied absolute path.
actual=$(find "$CASE_ROOT/level1" -type f -name coordinates.txt -exec sed -n '1p' {} \;)
check 1 "$actual"

# Level 2: follow the instructed relative route from work/current.
root=$(sed -n 's|^Begin in data/\([^/]*\)/work/current.*|\1|p' "$CASE_ROOT/level2/TASK.txt")
folder=$(sed -n 's|.*archive/\([^ ]*\) and reads.*|\1|p' "$CASE_ROOT/level2/TASK.txt")
item=$(sed -n 's|.*reads \([^ ]*\)\.txt.*|\1|p' "$CASE_ROOT/level2/TASK.txt")
actual=$(cd "$CASE_ROOT/level2/$root/work/current" && sed -n '1p' "../../archive/$folder/$item.txt")
check 2 "$actual"

# Level 3: include hidden entries in the search.
actual=$(find "$CASE_ROOT/level3" -type f -name '.*-key' -exec sed -n '1p' {} \;)
check 3 "$actual"

# Level 4: follow branch and section clues, then match content.
branch=$(sed -n 's/^BRANCH=//p' "$CASE_ROOT/level4/TASK.txt")
section=$(sed -n 's/^SECTION=//p' "$CASE_ROOT/level4/TASK.txt")
path=$(grep -l 'uniquely marked destination' "$CASE_ROOT/level4/$branch/$section"/*)
actual=$(printf '%s\n' "$path" | sed "s|$CASE_ROOT/level4/||")
check 4 "$actual"

# Level 5: use find name, type, size, and scope predicates.
item=$(sed -n 's/.*named \([^ ]*\)-\*\.dat.*/\1/p' "$CASE_ROOT/level5/TASK.txt")
size=$(sed -n 's/.*exact size is \([0-9]*\) bytes.*/\1/p' "$CASE_ROOT/level5/TASK.txt")
actual=$(find "$CASE_ROOT/level5/search" -type f -name "$item-*.dat" -size "${size}c" -exec sed -n '1p' {} \;)
check 5 "$actual"

# Level 6: combine exact find permission and byte-size predicates.
size=$(sed -n 's/.*exact size \([0-9]*\) bytes.*/\1/p' "$CASE_ROOT/level6/TASK.txt")
candidate=$(find "$CASE_ROOT/level6/candidates" -type f -perm 0640 -size "${size}c")
actual=$(basename "$candidate" .dat)
check 6 "$actual"

# Level 7: inspect and follow a relative symbolic link.
link="$CASE_ROOT/level7/links/current-key"
target=$(readlink "$link")
actual=$(cd "$(dirname "$link")" && sed -n '1p' "$target")
check 7 "$actual"

# Level 8: identify shared inodes rather than duplicate content.
actual=''
for left in "$CASE_ROOT/level8/records"/*; do
    for right in "$CASE_ROOT/level8/recovery"/*; do
        left_inode=$(ls -id "$left" | awk '{print $1}')
        right_inode=$(ls -id "$right" | awk '{print $1}')
        if [ "$left_inode" = "$right_inode" ]; then
            actual=$(printf '%s\n%s\n' "$(basename "$left")" "$(basename "$right")" |
                sort | awk 'NR==1 {a=$0} NR==2 {print a "|" $0}')
        fi
    done
done
check 8 "$actual"

# Level 9: resolve the relative link chain and normalize the test root.
actual_path=$(readlink -f "$CASE_ROOT/level9/links/current")
relative=$(printf '%s\n' "$actual_path" | sed "s|$CASE_ROOT/level9/||")
actual="/srv/filesystem-navigation/cases/level9/$relative"
check 9 "$actual"

# Level 10: resolve alias, verify mode and shared inode, then read the target.
alias_rel=$(sed -n 's/^ALIAS=//p' "$CASE_ROOT/level10/TASK.txt")
recovery_rel=$(sed -n 's/^RECOVERY=//p' "$CASE_ROOT/level10/TASK.txt")
target=$(readlink -f "$CASE_ROOT/level10/$alias_rel")
mode=$(ls -ld "$target" | awk '{print $1}')
link_count=$(ls -ld "$target" | awk '{print $2}')
target_inode=$(ls -id "$target" | awk '{print $1}')
recovery_inode=$(ls -id "$CASE_ROOT/level10/$recovery_rel" | awk '{print $1}')
if [ "$mode" = '-rw-r-----' ] && [ "$link_count" -eq 2 ] && [ "$target_inode" = "$recovery_inode" ]; then actual=$(sed -n '1p' "$target"); else actual=INVALID; fi
check 10 "$actual"

if [ "$failures" -ne 0 ]; then echo "$failures level(s) failed validation." >&2; exit 1; fi
echo "All levels passed."
