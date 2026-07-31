#!/bin/sh
set -eu

cd "$(dirname "$0")"
INSTALL_ROOT=$(pwd)
export INSTALL_ROOT
. "$INSTALL_ROOT/resources.sh"

SYSTEM_PASSWORD=${SYSTEM_PASSWORD:-systemPassword}
LEVEL_PASSWORD_ROOT=${LEVEL_PASSWORD_ROOT:-levelPassword}
currentDate=${CURRENT_DATE:-$(date +%Y-%m-%d)}
export SYSTEM_PASSWORD LEVEL_PASSWORD_ROOT currentDate

NON_INTERACTIVE=0
NO_LOGIN=0
for arg in "$@"; do
    case "$arg" in
        --non-interactive) NON_INTERACTIVE=1 ;;
        --no-login) NO_LOGIN=1 ;;
        *) die "unknown option: $arg" ;;
    esac
done

if [ "$NON_INTERACTIVE" -eq 1 ]; then
    USER_ID=${USER_ID:-student@example.edu}
else
    confirmation=n
    while [ "$confirmation" != y ]; do
        printf 'Enter your email address: '
        IFS= read -r USER_ID
        printf 'Is %s correct? (y/n) ' "$USER_ID"
        IFS= read -r confirmation
    done
fi
export USER_ID

for cmd in adduser awk base64 basename cat chmod chown cp cut date dirname find \
    grep head id ln ls mkdir passwd printf pwd readlink rm sed sha256sum sort \
    su tail touch tr wc; do
    command_required "$cmd"
done

LAB_PROFILE_PASSWORD="${LEVEL_PASSWORD_ROOT}Theme"
LAB_HASH=$(printf '%s%s%s%s' "$USER_ID" "$currentDate" "$SYSTEM_PASSWORD" \
    "$LAB_PROFILE_PASSWORD" | sha256sum | awk '{print $1}')
THEME_INDEX=$(lab_derive_hex theme | cut -c 1)
export LAB_HASH THEME_INDEX

mkdir -p /home /srv/filesystem-navigation/cases /var/lib/filesystem-navigation/answers
chmod 700 /var/lib/filesystem-navigation /var/lib/filesystem-navigation/answers
ANSWER_DIR=/var/lib/filesystem-navigation/answers
export ANSWER_DIR

cp "$INSTALL_ROOT/profile" /etc/profile
for command_file in nextlevel prevlevel checklevel; do
    cp "$INSTALL_ROOT/$command_file" "/usr/bin/$command_file"
    chmod 755 "/usr/bin/$command_file"
done

echo "Building 10 Filesystem Navigation levels using theme: $(theme_field title)"
levelnumber=1
while [ "$levelnumber" -le 10 ]; do
    levelToBuild="level$levelnumber"
    LEVEL_HOME="/home/$levelToBuild"
    levelPassword="${LEVEL_PASSWORD_ROOT}${levelnumber}"
    level_HASH=$(printf '%s%s%s%s' "$USER_ID" "$currentDate" "$SYSTEM_PASSWORD" \
        "$levelPassword" | sha256sum | awk '{print $1}')
    export levelnumber levelToBuild LEVEL_HOME levelPassword level_HASH
    if ! id "$levelToBuild" >/dev/null 2>&1; then adduser -D -g "Filesystem Navigation learner" "$levelToBuild"; fi
    passwd -d "$levelToBuild" >/dev/null 2>&1 || true
    case "$LEVEL_HOME" in /home/level[1-9]|/home/level10) rm -rf "$LEVEL_HOME" ;; *) die "refusing to reset unexpected home: $LEVEL_HOME" ;; esac
    mkdir -p "$LEVEL_HOME"
    echo "  $levelToBuild"
    sh "$INSTALL_ROOT/$levelToBuild.sh"
    levelnumber=$((levelnumber + 1))
done

echo "Build complete. Run ./verify.sh to validate generated levels."
if [ "$NO_LOGIN" -eq 0 ]; then exec su -l level1; fi
