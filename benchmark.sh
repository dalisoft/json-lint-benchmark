#!/bin/sh
set -eu

# Exports for binaries access
export PATH="./node_modules/.bin:$PATH"

json_files="package-template package-lock-test twitter"

# shellcheck disable=SC2034
for item in ${json_files}; do
  file="data/$item.json"
  hyperfine --runs 10 --warmup 3 "biome check $file" "prettier -c $file" "dprint check $file" "jsona fmt --option trailing_newline=true --check $file" "spectral lint --ignore-unknown-format $file" --export-markdown "results/$item.md" --ignore-failure
done
