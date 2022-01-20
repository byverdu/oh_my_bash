#!/bin/bash

# shellcheck source=/dev/null
source "$GLOBAL_PATH/oh_my_bash/custom.sh"

echo "What type of config do you want to install?";

read -r CONFIG_TYPE;

if [ "$CONFIG_TYPE" == "home" ];
  then
    printColors green "Setting a home machine config"
  else
    printColors green "Setting a job machine config"
fi

printColors green "installing Oh my Zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Installing Brew
printColors green "🤘 Installing brew.... 🤘"

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Installing dependencies through brew
printColors green "🤘 Installing brew packages.... 🤘"

# VSCode
brew tap homebrew/cask
brew install --cask visual-studio-code

# iTerm
brew install --cask iterm2

# postman
brew install --cask postman

# docker
brew install --cask docker

# robo-3t
brew install --cask robo-3t

# brave-browser
brew install --cask brave-browser

# yarn
brew install yarn

# python3
brew install python3

# slack
brew install --cask slack

# Fira Code
brew tap homebrew/cask-fonts
brew install --cask font-fira-code

# mongo
brew tap mongodb/brew
brew install mongodb-community@4.4

# node version manager
brew install nvm

# GitHub CLI
brew install gh

# shell bash syntax checker
brew install shellcheck

if [ "$CONFIG_TYPE" == "home" ];
  then
    printColors green "Installing personal packages"

    # vlc desktop app
    brew install --cask vlc

    # vnc client app
    brew install vnc-viewer

    # binance desktop app
    brew install binance

    # plex server
    brew install --cask plex

    # expressvpn
    brew install --cask expressvpn

    # transmission
    brew install --cask transmission

    # dropbox
    brew install --cask dropbox

    # whatsapp
    brew install --cask whatsapp

    # alfred
    brew install --cask alfred
fi

# Cloning repos
printColors green "🤘 Installing git repos.... 🤘"
cd ~/Projects/repos || exit

printColors green "🤘 Installing dracula theme.... 🤘"

git clone https://github.com/dracula/iterm.git


echo "# Appending custom bash config" >>  ~/.zshrc
echo "source ~/Projects/repos/oh_my_bash/custom.sh" >>  ~/.zshrc

printColors green "✋✋✋ setup script has finished ✋✋✋"
