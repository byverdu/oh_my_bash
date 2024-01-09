#!/bin/bash

HOST_NAME=$(hostname | cut -d"." -f1)
# shellcheck source=/dev/null
source "/Users/$HOST_NAME/Projects/repos/oh_my_bash/custom.sh"

if [ -d ~/.oh-my-zsh ]; then
  printColors orange "oh-my-zsh is installed"
else
  printColors green "Installing Oh my Zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# Installing Brew
printColors green "🤘 Installing brew.... 🤘"

if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  exit
else
  printColors orange "brew is installed"
fi

echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>/Users/$HOST_NAME/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

printColors green "setting github info"

# setting github info
# git config --global user.email "byverdu@gmail.com"
# git config --global user.name "Albert Vallverdu"

# Installing dependencies through brew
printColors green "🤘 Installing brew packages.... 🤘"

# Chrome
brew install --cask google-chrome

# Firefox
# brew tap homebrew/cask-versions
# brew install --cask firefox-developer-edition

# VSCode
brew tap homebrew/cask
brew install --cask visual-studio-code

# iTerm
brew install --cask iterm2

# postman
brew install --cask postman

# docker
brew install --cask docker

# mongo UI clients
# brew install --cask robo-3t
# brew install --cask studio-3t

# brave-browser
# brew install --cask brave-browser

# node
brew install node

# yarn
brew install yarn

# python3
brew install python3

# slack
# brew install --cask slack

# Fira Code
brew tap homebrew/cask-fonts
brew install --cask font-fira-code

# mongo
brew tap mongodb/brew
brew install mongodb-community@4.4

# GitHub CLI
brew install gh

# shell bash syntax checker
brew install shellcheck

# fig app terminal tool
brew install fig

# expressvpn
brew install --cask expressvpn

# higlight shell commands
brew install zsh-syntax-highlighting

# pnpm
brew install pnpm

# betterdisplay
brew install --cask betterdisplay

# microsoft teams
brew install --cask microsoft-teams

# runjs
brew install --cask runjs

# outlook
brew install --cask microsoft-outlook

# logitech options
brew install --cask logitech-options

# vlc desktop app
# brew install --cask vlc

# vnc client app
# brew install vnc-viewer

# binance desktop app
# brew install binance

# plex server
# brew install --cask plex

# transmission
# brew install --cask transmission

# dropbox
# brew install --cask dropbox

# whatsapp
# brew install --cask whatsapp

# alfred
# brew install --cask alfred

# Cloning repos
printColors green "🤘 Installing git repos.... 🤘"
cd ~/Projects/repos || exit

printColors green "🤘 Installing dracula theme.... 🤘"

git clone https://github.com/dracula/iterm.git

# Appending to zshrc
printColors green "🤘 Appending to zshrc 🤘"

printf "\n" >>~/.zshrc
echo "# Appending custom bash config" >>~/.zshrc

echo "export GLOBAL_PATH=/Users/$HOST_NAME/Projects" >>~/.zshrc
echo "source ~/Projects/repos/oh_my_bash/custom.sh" >>~/.zshrc
echo "source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >>~/.zshrc

printf "\n" >>~/.zshrc
printColors green "🤘 NVM setup 🤘"

echo "# NVM config" >>~/.zshrc

cd ~ || exit 1

git clone https://github.com/nvm-sh/nvm.git .nvm

cd ~/.nvm || exit 1

LATEST_NVM_TAG=$(git describe --abbrev=0 --tags)

git checkout "$LATEST_NVM_TAG"

# shellcheck source=/dev/null
. ./nvm.sh

printf "\n"
echo "export NVM_DIR=\"$HOME/.nvm\"" >>~/.zshrc
echo "[ -s $NVM_DIR/nvm.sh ] && \. $NVM_DIR/nvm.sh  # This loads nvm" >>~/.zshrc
echo "[ -s \"$NVM_DIR/bash_completion\" ] && \. \"$NVM_DIR/bash_completion\"  # This loads nvm bash_completion" >>~/.zshrc

printColors green "✋✋✋ setup script has finished ✋✋✋"
printColors green "✋✋✋ remember to install BetterDisplay ✋✋✋"
