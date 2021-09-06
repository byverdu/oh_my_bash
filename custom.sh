#!/bin/bash

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
alias iya="cd ~/Projects/iya"
alias repos="cd ~/Projects/repos"
alias create_repo="$GLOBAL_PATH/oh_my_bash && ./git_repos.sh"
alias git_name="git config --global user.name $1"
alias git_email="git config --global user.email $1"
alias iya-login="aws sso login --profile iya"

# Functions

function iya-clone () {
  git clone codecommit::eu-west-1://iya@$1
}

# AWS shortcut functions
function awsLamUpdateCode () {
    aws lambda update-function-code --function-name $1 $2
}

function killport () {
  lsof -ti tcp:$1 | xargs kill
  echo "port killed at $1"
}

function removeNumbersFromFileName () {
	for f in *$fileExtension
  do
    mv "$f" "${f//[0-9]*\-/}"
    # mv "$f" "${f//[0-9]*\-/}" => will remove hyphens (-) too
	done
}

function getAllFiles () {
  find $1 -type f -name "*.$2" > $2Files.txt
}

function printColors () {
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

source $GLOBAL_PATH/oh_my_bash/hidden.sh
