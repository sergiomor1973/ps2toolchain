#!/bin/bash
# 001-dvp.sh by ps2dev developers

# Abort on any error
set -e

onerr() {
    echo "ERROR: Script failed at line $1"
    exit 1
}
trap 'onerr $LINENO' ERR

## Read information from the configuration file.
source "$(dirname "$0")/../config/ps2toolchain-config.sh"

## Download the source code.
REPO_URL="$PS2TOOLCHAIN_DVP_REPO_URL"
REPO_REF="$PS2TOOLCHAIN_DVP_DEFAULT_REPO_REF"
REPO_FOLDER="$(s="$REPO_URL"; s=${s##*/}; printf "%s" "${s%.*}")"

# Checking if a specific Git reference has been passed in parameter $1
if test -n "$1"; then
  REPO_REF="$1"
  printf 'Using specified repo reference %s\n' "$REPO_REF"
fi

# Clone or update repository
if test ! -d "$REPO_FOLDER"; then
    echo "Cloning $REPO_URL ..."
    git clone --depth 1 -b "$REPO_REF" "$REPO_URL" "$REPO_FOLDER" || {
        echo "ERROR: Failed to clone $REPO_URL"
        exit 1
    }
else
    echo "Updating $REPO_FOLDER ..."
    git -C "$REPO_FOLDER" remote set-url origin "$REPO_URL"
    git -C "$REPO_FOLDER" fetch origin "$REPO_REF" --depth=1 || {
        echo "ERROR: Failed to fetch updates for $REPO_FOLDER"
        exit 1
    }
    git -C "$REPO_FOLDER" checkout -f FETCH_HEAD
fi

# Confirm folder exists
if test ! -d "$REPO_FOLDER"; then
    echo "ERROR: Folder $REPO_FOLDER missing after clone"
    exit 1
fi
