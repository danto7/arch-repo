#!/usr/bin/env bash
set -euo pipefail
package_name="$1"

if [ -d "$package_name" ]; then
  git --git-dir "$package_name" reset --hard
  git --git-dir "$package_name" pull
else
  git clone "https://aur.archlinux.org/$package_name.git" "$package_name"
fi

cd "$package_name"

makepkg -s
