#!/bin/sh
#Usage: git commit --amend --author "Per Hansson Adrian <per.hansson80@gmail.com>" --no-edit
AUTHOR=$1
echo "New author: ${AUTHOR}"
git commit --amend --author "$AUTHOR" --no-edit


