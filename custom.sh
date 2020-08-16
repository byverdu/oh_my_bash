#!/bin/bash

# oh-my-zsh theme
echo "🤘 \x1b[35mSetting zsh theme, alias and functions....\x1b[0m 🤘"

ZSH_THEME=""
PROMPT='%{$fg_bold[green]%}➜ %{$fg_bold[green]%}%p %{$fg_bold[blue]%}%~ $(git_prompt_info)% $(git_prompt_status)% %{$reset_color%}
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

# Aliases for quick access commands
alias server="python -m SimpleHTTPServer 8888"
alias myserver="ssh marla@146.185.129.77"
alias myip="echo $(ipconfig getifaddr $(route get example.com | grep -o 'en[^d]'))"
alias ports="lsof -n | grep LISTEN"
alias chromeRaw="open /Applications/Google\ Chrome.app --args --user-data-dir=\"/var/tmp/Chrome_dev_2\" --disable-web-security --disable-site-isolation-trials"
alias mongo-start="brew services start mongodb-community@4.4"
alias mongo-stop="brew services stop mongodb-community@4.4"

# Functions

# AWS shortcut functions
function awsLamUpdateCode () {
    aws lambda update-function-code --function-name $1 $2
}

function killport () {
    lsof -ti tcp:$1 | xargs kill
    echo "port killed at $1"
}
