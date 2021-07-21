#!/bin/bash

# Installing Brew
echo "🤘 \x1b[35mInstalling brew....\x1b[0m 🤘"

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Installing dependencies through brew
echo "🤘 \x1b[35mInstalling brew packages....\x1b[0m 🤘"

# VSCode
brew tap homebrew/cask
brew cask install visual-studio-code

# iTerm
brew cask install iterm2

# postman
brew cask install postman

# dropbox
brew cask install dropbox

# docker
brew cask install docker

# whatsapp
brew cask install whatsapp

# alfred
brew cask install alfred

# robo-3t
brew cask install robo-3t

# brave-browser
brew cask install brave-browser

# yarn
brew install yarn

# python3
brew install python3

# slack
brew cask install slack

# ZSH
brew install zsh
# install Oh my Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Fira Code
brew tap homebrew/cask-fonts
brew cask install font-fira-code

# mongo
brew tap mongodb/brew
brew install mongodb-community@4.4

# node version manager
brew install n

# GitHub CLI
brew install gh

# VLC
brew cask install vlc

# Cloning repos
# Dracula theme

echo "🤘 \x1b[35mInstalling git repos....\x1b[0m 🤘"
cd ~/Projects/repos

echo "🤘 \x1b[35mInstalling dracula theme....\x1b[0m 🤘"
git clone https://github.com/dracula/iterm.git



echo "# Appending custom bash config" >>  ~/.zshrc
echo "source ~/Projects/repos/oh_my_bash/custom.sh" >>  ~/.zshrc


echo "✋✋✋ \x1b[32msetup script has finished\x1b[0m ✋✋✋"
