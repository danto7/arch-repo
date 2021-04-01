#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
WHITE='\033[0;37m'
RESET='\033[0m'

aur_packages=("glow")
image_name="arch_package_builder"

function info(){
  echo -e "${WHITE}> ${GREEN}$1${RESET}"
}

function rebuild_image(){
  info "rebuilding image"
  docker build -t "$image_name" .
}

if docker image inspect "$image_name" &> /dev/null ;then
  image_creation_date="$(docker image inspect arch_package_builder --format '{{.Metadata.LastTagTime}}' | cut -d' ' -f1)"
  if [ "$image_creation_date" != "$(date +%Y-%m-%d)" ]; then
    info "image '$image_name' outdated"
    docker image rm "$image_name"
    rebuild_image
  else
    info "image '$image_name' already up to date"
  fi
else
  rebuild_image
fi


for package_name in "${aur_packages[@]}"; do
  info "building package '$package_name'"
  build_dir="$(pwd)/builds/"

  docker run -it --rm -v "$build_dir:/home/builder" "$image_name" "$package_name"
done
