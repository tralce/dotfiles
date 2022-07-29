#!/bin/bash
if [ -d .git ]
then
  git add -A .
  git commit -m "$*"
  git push
  exit 0
else
  echo "Check yourself before you wreck yourself!"
  exit 1
fi
