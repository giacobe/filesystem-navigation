#!/bin/sh

die() {
    echo "ERROR: $*" >&2
    exit 1
}

command_required() {
    command -v "$1" >/dev/null 2>&1 || die "required command not found: $1"
}

derive_hex() {
    label=$1
    printf '%s:%s' "$level_HASH" "$label" | sha256sum | awk '{print $1}'
}

lab_derive_hex() {
    label=$1
    printf '%s:%s' "$LAB_HASH" "$label" | sha256sum | awk '{print $1}'
}

hex_byte() {
    hex=$1
    index=$2
    start=$((index * 2 + 1))
    pair=$(printf '%s' "$hex" | cut -c "$start-$((start + 1))")
    printf '%d\n' "$((0x$pair))"
}

range_from_byte() {
    byte=$1
    minimum=$2
    maximum=$3
    printf '%d\n' "$((minimum + byte % (maximum - minimum + 1)))"
}

base64url_digest() {
    printf '%s' "$1" | base64 | tr -d '\r\n=' | tr '+/' '-_'
}

answer_token() {
    length=$1
    base64url_digest "$(derive_hex answer)" | cut -c "1-$length"
}

pick_word() {
    label=$1
    shift
    words="$*"
    hex=$(derive_hex "$label")
    byte=$(hex_byte "$hex" 0)
    count=$#
    wanted=$((byte % count + 1))
    index=1
    for word in $words; do
        if [ "$index" -eq "$wanted" ]; then
            printf '%s\n' "$word"
            return
        fi
        index=$((index + 1))
    done
}

theme_field() {
    field=$1
    case "$THEME_INDEX:$field" in
        0:title) printf 'Space mission control' ;; 0:root) printf missions ;; 0:item) printf telemetry ;; 0:place) printf module ;;
        1:title) printf 'Oceanographic expedition' ;; 1:root) printf expeditions ;; 1:item) printf sonar ;; 1:place) printf vessel ;;
        2:title) printf 'Wildlife conservation' ;; 2:root) printf habitats ;; 2:item) printf observation ;; 2:place) printf station ;;
        3:title) printf 'Archaeological dig' ;; 3:root) printf excavations ;; 3:item) printf artifact ;; 3:place) printf trench ;;
        4:title) printf 'Museum collection' ;; 4:root) printf collections ;; 4:item) printf accession ;; 4:place) printf gallery ;;
        5:title) printf 'Public library archive' ;; 5:root) printf archives ;; 5:item) printf catalog ;; 5:place) printf branch ;;
        6:title) printf 'Film production' ;; 6:root) printf productions ;; 6:item) printf take ;; 6:place) printf studio ;;
        7:title) printf 'Music festival' ;; 7:root) printf festivals ;; 7:item) printf setlist ;; 7:place) printf stage ;;
        8:title) printf 'Rail network operations' ;; 8:root) printf railways ;; 8:item) printf signal ;; 8:place) printf station ;;
        9:title) printf 'Airport baggage system' ;; 9:root) printf baggage ;; 9:item) printf routing ;; 9:place) printf terminal ;;
        a:title) printf 'Weather monitoring' ;; a:root) printf weather ;; a:item) printf reading ;; a:place) printf station ;;
        b:title) printf 'Renewable energy grid' ;; b:root) printf energy ;; b:item) printf output ;; b:place) printf substation ;;
        c:title) printf 'Robotics workshop' ;; c:root) printf robotics ;; c:item) printf calibration ;; c:place) printf workshop ;;
        d:title) printf 'Botanical research garden' ;; d:root) printf gardens ;; d:item) printf specimen ;; d:place) printf greenhouse ;;
        e:title) printf 'Medieval kingdom archive' ;; e:root) printf kingdom ;; e:item) printf decree ;; e:place) printf castle ;;
        f:title) printf 'Interplanetary cargo company' ;; f:root) printf cargo ;; f:item) printf manifest ;; f:place) printf depot ;;
        *) die "unknown theme field: $THEME_INDEX:$field" ;;
    esac
}

write_readme() {
    instructions=$1
    {
        echo "Theme: $(theme_field title)"
        echo "Learner: $USER_ID"
        echo "Collection date: $currentDate"
        echo "************************************************************************"
        printf '%s\n' "$instructions"
    } > "$LEVEL_HOME/README.txt"
}

fresh_case() {
    case "$levelToBuild" in level[1-9]|level10) ;; *) die "refusing unexpected level name: $levelToBuild" ;; esac
    CASE_DIR="${CASE_ROOT:-/srv/filesystem-navigation/cases}/$levelToBuild"
    case "$CASE_DIR" in */level[1-9]|*/level10) ;; *) die "refusing unexpected case path: $CASE_DIR" ;; esac
    rm -rf "$CASE_DIR"
    mkdir -p "$CASE_DIR"
    ln -s "$CASE_DIR" "$LEVEL_HOME/data"
    export CASE_DIR
}

finish_level() {
    if [ "${SKIP_OWNERSHIP:-0}" -eq 1 ]; then
        return
    fi
    chown -R "$levelToBuild:$levelToBuild" "$LEVEL_HOME" "$CASE_DIR"
    find "$CASE_DIR" -type d -exec chmod 750 {} \;
    find "$CASE_DIR" -type f -exec chmod 640 {} \;
    chmod 700 "$LEVEL_HOME"
}
