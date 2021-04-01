#!/usr/bin/env bash
set -euo pipefail
package_name="$1"
cd "$package_name"

if [ -d "$package_name" ]; then
  git reset --hard
  git pull
else
  git clone "https://aur.archlinux.org/$package.git" "$package_name"
fi

makepkg -s
