#!/bin/sh
set -eu

# Exports for binaries access
export PATH="./node_modules/.bin:$PATH"

json_files="package-template package-lock-test twitter"

prepare() {
  /bin/rm -rf "$HOME/Library/Caches/deno/fmt_*"
}

# shellcheck disable=SC3045
export -f prepare

# shellcheck disable=SC2034
for item in ${json_files}; do
  file="data/$item.json"
  hyperfine --runs 3 "biome format $file" "prettier -c $file" "./node_modules/dprint/bin.js check $file" "./node_modules/dprint-rs-npm/dprint check $file" "deno fmt $file" "jsona fmt --option trailing_newline=true --check $file" "spectral lint --ignore-unknown-format $file" --export-markdown "results/$item.md" --prepare prepare
done
