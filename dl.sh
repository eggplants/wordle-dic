#!/usr/bin/env bash

set -euo pipefail

f='wordle_valid_word_dictionary.txt'
s='https://www.powerlanguage.co.uk/wordle/main.e65ce0a5.js'

if ! command -v curl &> /dev/null; then
  echo 'err: install curl' >&2
  exit 1
fi

: >> "$f"

f_tmp="$(mktemp)"
curl -s "$s" |
  grep -o 'var La.*],Ia=' | grep -oE '\"[a-z]{5}\"' |
  xargs -n1 | sort | uniq > "$f_tmp"

l_old="$(wc -l < "$f")"
s_old="$(sha256sum "$f" | cut -f1 -d ' ')"
l_new="$(wc -l < "$f_tmp")"
s_new="$(sha256sum "$f_tmp" | cut -f1 -d ' ')"

if {
  [ "$l_new" -gt 10000 ] &&
  [ "$s_old" != "$s_new" ]
}; then
  echo "${l_old} (${s_old}) -> ${l_new} (${s_new})"
  mv "$f_tmp" "$f"
else
  echo "(no changed)"
fi
