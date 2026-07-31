#!/bin/sh
set -eu

cd "$(dirname "$0")"
INSTALL_ROOT=$(pwd)
export INSTALL_ROOT
. "$INSTALL_ROOT/resources.sh"

test_root=$(mktemp -d "${TMPDIR:-/tmp}/polylinux-filesystem-navigation.XXXXXX")
trap 'rm -rf "$test_root"' EXIT HUP INT TERM

generate_case() {
    case_name=$1
    case_user=$2
    case_date=$3
    case_root="$test_root/$case_name"
    USER_ID=$case_user
    currentDate=$case_date
    SYSTEM_PASSWORD=exercisePassword
    LEVEL_PASSWORD_ROOT=levelPassword
    LAB_PROFILE_PASSWORD="${LEVEL_PASSWORD_ROOT}Theme"
    LAB_HASH=$(printf '%s%s%s%s' "$USER_ID" "$currentDate" "$SYSTEM_PASSWORD" "$LAB_PROFILE_PASSWORD" | sha256sum | awk '{print $1}')
    THEME_INDEX=$(lab_derive_hex theme | cut -c 1)
    ANSWER_DIR="$case_root/answers"
    CASE_ROOT="$case_root/cases"
    SKIP_OWNERSHIP=1
    export USER_ID currentDate SYSTEM_PASSWORD LEVEL_PASSWORD_ROOT LAB_HASH THEME_INDEX ANSWER_DIR CASE_ROOT SKIP_OWNERSHIP
    mkdir -p "$case_root/home" "$ANSWER_DIR" "$CASE_ROOT"
    levelnumber=1
    while [ "$levelnumber" -le 10 ]; do
        levelToBuild="level$levelnumber"
        LEVEL_HOME="$case_root/home/$levelToBuild"
        levelPassword="${LEVEL_PASSWORD_ROOT}${levelnumber}"
        level_HASH=$(printf '%s%s%s%s' "$USER_ID" "$currentDate" "$SYSTEM_PASSWORD" "$levelPassword" | sha256sum | awk '{print $1}')
        export levelnumber levelToBuild LEVEL_HOME levelPassword level_HASH
        rm -rf "$LEVEL_HOME"
        mkdir -p "$LEVEL_HOME"
        sh "$INSTALL_ROOT/$levelToBuild.sh"
        levelnumber=$((levelnumber + 1))
    done
}

snapshot_case() {
    root=$1
    find "$root" -type f -exec sha256sum {} \; | sed "s|$root/||" | sort
    find "$root" -type l -exec sh -c 'for p do printf "%s -> %s\n" "$p" "$(readlink "$p")"; done' sh {} + | sed "s|$root/||" | sort
    find "$root" -type f -exec ls -ld {} \; | awk '{print $1, $2, $5, $NF}' | sed "s|$root/||" | sort
}

echo "generate fixed case A"
generate_case case-a student@example.edu 2026-07-31
echo "verify all reference solvers"
CASE_ROOT="$test_root/case-a/cases" ANSWER_DIR="$test_root/case-a/answers" sh "$INSTALL_ROOT/verify.sh"

echo "test target uniqueness and link invariants"
[ "$(find "$test_root/case-a/cases/level3" -type f -name '.*-key' | wc -l | tr -d ' ')" -eq 1 ]
size=$(sed -n 's/.*exact size is \([0-9]*\) bytes.*/\1/p' "$test_root/case-a/cases/level5/TASK.txt")
item=$(sed -n 's/.*named \([^ ]*\)-\*\.dat.*/\1/p' "$test_root/case-a/cases/level5/TASK.txt")
[ "$(find "$test_root/case-a/cases/level5/search" -type f -name "$item-*.dat" -size "${size}c" | wc -l | tr -d ' ')" -eq 1 ]
[ -L "$test_root/case-a/cases/level7/links/current-key" ]
[ "$(ls -ld "$test_root/case-a/cases/level8/records"/* | awk '{print $2}' | sort -nr | sed -n '1p')" -eq 2 ]
recovery_file=$(find "$test_root/case-a/cases/level10/recovery" -type f | sed -n '1p')
[ "$(ls -ld "$recovery_file" | awk '{print $2}')" -eq 2 ]

echo "test identical-input repeatability"
snapshot_case "$test_root/case-a" > "$test_root/snapshot-a"
generate_case case-a student@example.edu 2026-07-31
snapshot_case "$test_root/case-a" > "$test_root/snapshot-a-rerun"
cmp "$test_root/snapshot-a" "$test_root/snapshot-a-rerun"

echo "test changed-learner and changed-date variation"
generate_case case-b second.student@example.edu 2026-07-31
! cmp -s "$test_root/case-a/answers/level10" "$test_root/case-b/answers/level10"
generate_case case-c student@example.edu 2026-08-01
! cmp -s "$test_root/case-a/answers/level6" "$test_root/case-c/answers/level6"

echo "test all 16 theme mappings"
for THEME_INDEX in 0 1 2 3 4 5 6 7 8 9 a b c d e f; do
    export THEME_INDEX
    [ -n "$(theme_field title)" ]
    [ -n "$(theme_field root)" ]
    [ -n "$(theme_field item)" ]
done

echo "test root login profile and answer modes"
grep -q '^dmesg -n1$' "$INSTALL_ROOT/.profile"
grep -q '^\./install\.sh$' "$INSTALL_ROOT/.profile"
find "$test_root/case-a/answers" -type f -exec chmod 600 {} \;
[ -z "$(find "$test_root/case-a/answers" -type f ! -perm 600)" ]

echo "test required-command detection"
if (command_required definitely-not-a-polylinux-command) >/dev/null 2>&1; then die "missing command accepted"; fi

echo "All deterministic tests passed."
