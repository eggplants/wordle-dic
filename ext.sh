#!/usr/bin/env bash

set -euo pipefail

if ! [ -f EIJIRO-1448.utf8.TXT ]; then
  echo "'EIJIRO-1448.utf8.TXT' is not found." >&2
  exit 1
elif ! [ -f wordle_valid_word_dictionary.txt ]; then
  echo "'wordle_valid_word_dictionary.txt' is not found." >&2
  exit 1
fi
n="$(wc -l < wordle_valid_word_dictionary.txt)"
c=0
while read i; do
  echo -n -e "[$c/$n]:$i\r">&2
  echo -e "${i}\t$(
    {
      grep -E "^■${i}  \{[^}]+\} :" EIJIRO-1448.utf8.TXT ||
      grep -E "^■${i%s}  \{[^}]+\} :" EIJIRO-1448.utf8.TXT ||
      grep -E "^■${i%es}  \{[^}]+\} :" EIJIRO-1448.utf8.TXT ||
      grep -E "^■${i%es}  \{[^}]+\} :" EIJIRO-1448.utf8.TXT ||
      grep -E "^■${i%ed}  \{[^}]+\} :" EIJIRO-1448.utf8.TXT || :
    } |
    sed -r 's/^■[^:]+: *//' | tr -d '\r' |
    sed -z 's/\n/➖/g' | sed 's/➖$//'
  )"
  ((c++))
done < wordle_valid_word_dictionary.txt > wordle_ja.tsv
