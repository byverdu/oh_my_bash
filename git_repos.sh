#!/bin/bash

source $GLOBAL_PATH/oh_my_bash/custom.sh

# Create github repos programatically

gh --version || { printColors red "Github CLI is not installed https://github.com/cli/cli#installation" ; exit 1; }

if [ -z $1 ]
  then
    printColors red "Repository name must exist"
    exit 1
fi

mkdir "$GLOBAL_PATH/$1" && cd $_

git init

printColors green "Updating git name and email"

git config user.email "byverdu@gmail.com"
git config user.name "Albert Vallverdu"

cat .git/config

printColors green "Creating repo at GitHub"

# create a repository with a specific name
# gh repo create $1
# -y, --confirm Confirm the submission directly
# -d, --description string  Description of repository
# --public Make the new repository public

gh repo create $1 -y -d "$1 description" --public || { printColors red "Creating $1 failed" ; exit 1; }

printColors green "Creating repo files"

echo "# $1" >> README.md

echo -e "node_modules
yarn-error.log
.DS_Store
.vscode" >> .gitignore

npm init --yes

git add .
git commit -m "initial repo setup"
git push origin master

printColors green "All done :)"