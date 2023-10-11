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

# git diff [<options>] [--] <path>
# git diff --name-only, show only names of changed files
# git diff --diff-filter=ACMR, Added-Copied-Modified-Renamed
# git diff current_branch_name -- paths_to_filter

# cut -f 1 -d '.' remove file extension
# tr "\n" "|" replace new lines with the "|" char
# sed 's/.$//' remove last char ( a "|" char is added at the end on the previous command)

# COMPONENTS_FOLDER=libs/components/src/lib
# APPLICATION_FOLDER=apps/frontend/src
# CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# FILES_WITH_CHANGES=$(git diff --diff-filter=ACMR --name-only "origin/${CURRENT_BRANCH}" -- "${COMPONENTS_FOLDER}" "${APPLICATION_FOLDER}")

# FILES_PATHS=$(echo "${FILES_WITH_CHANGES}" | cut -f 1 -d '.' | tr "\n" "|" | sed 's/.$//')

# if [ "${FILES_WITH_CHANGES}" = "" ]; then
#     echo "No tests found to run."

#     exit 0;
# fi

# npx jest -- --findRelatedTests "${FILES_PATHS}"
