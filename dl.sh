#!/usr/bin/env bash

set -euxo pipefail

f='wordle_valid_word_dictionary.txt'
s='https://www.powerlanguage.co.uk/wordle/main.e65ce0a5.js'

if ! command -v curl &> /dev/null; then
  echo 'err: install curl' >&2
  exit 1
fi

f_tmp="$(mktemp)"
curl -s "$s" |
  grep -o 'var La.*],Ia=' | grep -oE '\"[a-z]{5}\"' |
  xargs -n1 | sort | uniq > "$f_tmp"

l="$(wc -l < "$f_tmp")"
if {
  ! [ -f "$f" ] ||
  [ "$(wc -l < "$f")" -ne "$l" ]
}; then
  mv "$f_tmp" "$f"
fi
