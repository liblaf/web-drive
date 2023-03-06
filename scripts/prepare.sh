#!/usr/bin/bash
set -o errexit
set -o nounset
set -o pipefail

function exists() {
  command -v "${@}" > /dev/null 2>&1
}

function run() {
  if exists gum; then
    local prefix="$(gum style --background=14 --padding="0 1" RUN)"
    local message="$(gum style --foreground=14 "${*}")"
    gum join --horizontal "${prefix}" " " "${message}"
  fi
  "${@}"
}

workspace="$(git rev-parse --show-toplevel || pwd)"
source="${workspace}/onedrive-vercel-index"
target="${workspace}/dist"
cd "${workspace}"

run rm --force --recursive "${target}"
run cp --recursive "${source}" "${target}"
run rm --force --recursive "${target}/.git"
run cp --recursive "${workspace}/config" "${target}/"
run cp --recursive "${workspace}/vercel.json" "${target}/"

run wget --output-document="${target}/public/favicon.ico" https://assets.liblaf.me/favicon/ico/d.ico
run wget --output-document="${target}/public/favicon.png" https://assets.liblaf.me/favicon/png/d.png
