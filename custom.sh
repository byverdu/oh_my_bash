#!/bin/bash

# oh-my-zsh theme
printf "🤘 \x1b[35mSetting zsh theme, alias and functions....\x1b[0m 🤘\n"

# Aliases for git
alias g-a="git add"
alias g-c="git commit -m"
alias g-ac="git commit -am"
alias g-b="git branch"
alias g-o="git checkout"
alias g-hi="git log --pretty=format:'%Cred%h%Creset %Cblue%ad%Creset | %s %Cgreen[%an]%Creset %d' --graph"
alias g-s="git status"
alias g-del-rem="git push origin --delete"
alias g-name="git commit --amend --author=\"Albert Vallverdu <byverdu@gmail.com>\" --no-edit"
alias g-d="git branch | grep -v 'master' | xargs git branch -D"

# Aliases for quick access commands
alias server="python -m SimpleHTTPServer 8888"
alias myip="echo $(ipconfig getifaddr $(route get example.com | grep -o 'en[^d]'))"
alias ports="lsof -n | grep LISTEN"
alias chromeRaw="cd / && open /Applications/Google\ Chrome\ Canary.app --args --user-data-dir=\"/var/tmp/Chrome_dev_2\" --disable-web-security --disable-site-isolation-trials"
alias mongo-start="brew services start mongodb-community@4.4"
alias mongo-stop="brew services stop mongodb-community@4.4"
alias repos="cd ~/Projects/repos"
alias git_name="git config --global user.name $1"
alias git_email="git config --global user.email $1"

# Functions

function killport() {
  lsof -ti tcp:"$1" | xargs kill || echo "killport() failed"
  echo "port killed at $1"
}

function removeNumbersFromFileName() {
  for f in *$fileExtension; do
    mv "$f" "${f//[0-9]*\-/}"
    # mv "$f" "${f//[0-9]*\-/}" => will remove hyphens (-) too
  done
}

function getAllFiles() {
  find "$1" -type f -name "*.$2" > "$2"Files.txt
}

printColors() {
  case "$1" in
  "red") echo -e "\033[1;31m$2\033[0m" ;;
  "green") echo -e "\033[1;32m$2\033[0m" ;;
  "orange") echo -e "\033[1;33m$2\033[0m" ;;
  *) echo "$2" ;;
  esac
}

function findAndMove() {
  if [ -z "$1" ] || [ -z "$2" ]; then
    printColors red "find pattern must be a string regex and destination path must be relative to the actual folder. Both need to be defined"
    return
  fi

  find . -maxdepth 1 -name "$1" -exec mv {} "$2" \;
}

function create_repo() {
  # Create github repos programatically

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

  git remote add origin git@github.com-byverdu:byverdu/"$1".git # "-byverdu:" is used so we can have 2 git accounts in the same computer

  git push -u origin main

  printColors green "All done :)"
}

