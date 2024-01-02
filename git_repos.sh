#!/bin/bash
# Create github repos programmatically

# shellcheck source=/dev/null
source "$GLOBAL_PATH"/repos/oh_my_bash/custom.sh

unset GITHUB_TOKEN

gh --version || {
  printColors red "Github CLI is not installed https://github.com/cli/cli#installation"
  exit 1
}

if [ -z "$1" ]; then
  printColors red "Repository name must exist"
  exit 1
fi

mkdir "$GLOBAL_PATH/repos/$1"
cd "$GLOBAL_PATH/repos/$1" || exit

git init

printColors green "Updating git name and email"

git config user.email "byverdu@gmail.com"
git config user.name "Albert Vallverdu"
# allow git to push to the current branch even if it is not tracking any branch
git config --global --add --bool push.autoSetupRemote true

cat .git/config

printColors green "Creating repo at GitHub"

# create a repository with a specific name
# gh repo create $1
# -d, --description string Description of repository
# --public Make the new repository public

printColors green "Creating repo files"

echo "# $1" >>README.md

echo -e "node_modules
yarn-error.log
.DS_Store
.vscode
/dist
/coverage
.env" >>.gitignore

npm init --yes

git add .
git commit -m "initial repo setup"

gh repo create "$1" -d "$1 description" --public || { printColors red "Creating $1 failed"; }

git branch -M master

git remote add origin git@github.com-byverdu:byverdu/"$1".git # "-byverdu:" is used so we can have 2 git accounts in the same computer

git push -u origin master

printColors green "All done :)"
