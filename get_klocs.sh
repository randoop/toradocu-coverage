#!/bin/bash

set -e
set -x
set -o pipefail

CORPUSDIR=toradocu
for dirname in $CORPUSDIR/*; do
  [ -d "$dirname" ] || continue

  basename=`basename $dirname`
  log="$CORPUSDIR/logs/$basename-klocs-log.txt"

  if [[ -e "$dirname/build.gradle" ]]; then
    echo "counting $basename"
#     ./count-klocs.pl "$basename" &> "$log"
    ./count-klocs.pl "$dirname" 
  fi
done
