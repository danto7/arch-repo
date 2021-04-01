#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
WHITE='\033[0;37m'
RESET='\033[0m'

function info(){
  echo -e "${WHITE}> ${GREEN}$1${RESET}"
}
aur_packages=("glow")

image_name="arch_package_builder"

if docker image inspect "$image_name" &> /dev/null ;then
  info "remove old image '$image_name'"
  docker image rm "$image_name"
fi
info "rebuilding image"
docker build -t "$image_name" .

for package_name in "${aur_packages[@]}"; do
  info "building package '$package_name'"
  build_dir="$(pwd)/builds/"

  docker run -it --rm -v "$build_dir:/home/builder" "$image_name" "$package_name"
done
