#!/bin/bash

listFiles=`ls content | cut -f 1 -d '.'`
for file in $listFiles
do
  mkdir public/$file
  FILENAME=$file npm run build
done

exit 0