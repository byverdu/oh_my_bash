#!/bin/bash

CONFIG_TYPE="personal"

# oh-my-zsh theme
echo "🤘 \x1b[35mSetting zsh theme, alias and functions....\x1b[0m 🤘"

ZSH_THEME=""
PROMPT='%{$fg_bold[green]%} %T %B%30 ➜%{$fg_bold[green]%}%p %{$fg_bold[blue]%}`pwd` $(git_prompt_info)% $(git_prompt_status)% %{$reset_color%}
$ '
ZSH_THEME_GIT_PROMPT_CLEAN=") %{$fg_bold[green]%}✔ "
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ✹"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ═"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭"

# Alias

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

# AWS shortcut functions

function killport() {
  lsof -ti tcp:$1 | xargs kill
  echo "port killed at $1"
}

function removeNumbersFromFileName() {
  for f in *$fileExtension; do
    mv "$f" "${f//[0-9]*\-/}"
    # mv "$f" "${f//[0-9]*\-/}" => will remove hyphens (-) too
  done
}

function getAllFiles() {
  find $1 -type f -name "*.$2" >$2Files.txt
}

function printColors() {
  red='\033[0;31m'
  green='\033[0;32m'
  orange='\033[1;33m'
  end="\033[0m"

  case $1 in
  "red")
    color=$red
    ;;

  "green")
    color=$green
    ;;

  "orange")
    color=$orange
    ;;
  esac

  echo -e "${color}$2${end}"
}

function create_repo() {
  # Create github repos programatically

  unset GITHUB_TOKEN

  gh --version || {
    printColors red "Github CLI is not installed https://github.com/cli/cli#installation"
    exit 1
  }

  if [ -z $1 ]; then
    printColors red "Repository name must exist"
    exit 1
  fi

  mkdir "$GLOBAL_PATH/$1"
  cd "$GLOBAL_PATH/$1" || exit

  git init

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
  .vscode" >>.gitignore

  npm init --yes

  printColors green "Changing default branch to master"
  git branch -M master
  git remote add origin git@github.com:byverdu/"$1".git

  printColors green "Committing files"
  git add .
  git commit -m "initial repo setup"

  printColors green "Creating repo with gh CLI"
  gh repo create $1 -d "$1 description" --public || { printColors red "Creating $1 failed"; }

  git push -u origin master

  printColors green "All done :)"
}

source "$GLOBAL_PATH/oh_my_bash/hidden.sh"

if [ $CONFIG_TYPE = "job" ]; then
  source "$GLOBAL_PATH/oh_my_bash/job.sh"
fi
