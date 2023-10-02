#!/bin/sh

# Run only tests depending on which folder has files changed

# husky runs the script using "sh" which will stop the execution as soon as any command returns a non-zero status
# github issue https://github.com/typicode/husky/issues/971
# github solution https://github.com/typicode/husky/issues/1142

# Allow exit codes
set +e

. "$(dirname -- "$0")/_/husky.sh"

# git diff [<options>] [--] <path>
# git diff --quiet, Disable all output of the program. Implies --exit-code.
# git diff --exit-code, Exits with 1 if there were differences and 0 means no differences
# $? is a variable that holds the exit status of the previously executed command

prettyEcho() {
  echo "\033[0;32m $1 \033[0m"
}

COMPONENTS_FOLDER=libs/components/src/lib
APPLICATION_FOLDER=apps/frontend/src
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

prettyEcho "Checking $COMPONENTS_FOLDER files"

git diff --quiet --stat "origin/$CURRENT_BRANCH" -- $COMPONENTS_FOLDER

if [ $? -eq 0 ]; then
  prettyEcho "No changes found in $COMPONENTS_FOLDER"
  prettyEcho "Checking $APPLICATION_FOLDER files"

  git diff --quiet --stat "origin/$CURRENT_BRANCH" -- $APPLICATION_FOLDER

  if [ $? -eq 0 ]; then
    prettyEcho "No changes found in $APPLICATION_FOLDER"
  else
    npm run test:frontend
  fi

else
  npm run test:frontend && npm run test:components
fi
