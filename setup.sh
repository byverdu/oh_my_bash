#!/bin/bash

HOST_NAME=$(hostname | cut -d"." -f1)
ZSH_PATH=~/.zshrc
# shellcheck source=/dev/null
source "/Users/$HOST_NAME/Projects/repos/oh_my_bash/custom.sh"


# setting github info
# git config --global user.email "byverdu@gmail.com"
# git config --global user.name "Albert Vallverdu"

# Installing dependencies through brew
printColors green "🤘 Installing UI applications.... 🤘"

brew install --cask expressvpn
brew install --cask cursor
brew install --cask amazon-q
brew install --cask raycast
brew install --cask google-chrome
brew tap homebrew/cask-versions
brew install --cask firefox-developer-edition
brew tap homebrew/cask
brew install --cask visual-studio-code
brew install --cask iterm2
brew install --cask postman
brew install --cask docker
brew install --cask ghostty
brew install --cask jetbrains-toolbox
brew install --cask robo-3t
brew install --cask studio-3t
brew install --cask brave-browser
brew install --cask betterdisplay
brew install --cask microsoft-teams
brew install --cask runjs
brew install --cask microsoft-outlook
brew install --cask logi-options+
brew install --cask vlc
brew install vnc-viewer
brew install --cask plex-media-server
brew install --cask transmission
brew install --cask dropbox
brew install --cask whatsapp
brew install --cask slack

printColors green "🤘 Installing fonts.... 🤘"

brew tap homebrew/cask-fonts
brew install --cask font-fira-code
brew install --cask font-jetbrains-mono
brew install --cask font-meslo-lg-nerd-font

printColors green "🤘 Installing CLI programs.... 🤘"

brew install deno
brew install node
brew install yarn
brew install python3
brew install tree
brew install pnpm
brew tap mongodb/brew
brew install mongodb-community@4.4
brew install gh
brew install shellcheck
brew install bat
brew install jandedobbeleer/oh-my-posh/oh-my-posh

{
  echo "# Custom config"
  echo "export GLOBAL_PATH=/Users/$HOST_NAME/Projects"
  echo "source ~/Projects/repos/oh_my_bash/custom.sh"
  echo "source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  echo "export BAT_THEME=\"base16\""
  echo "eval \"$(oh-my-posh init zsh)\""
} >> $ZSH_PATH

printColors green "🤘 NVM setup 🤘"

echo "# NVM config" >> $ZSH_PATH

cd ~ || exit 1

git clone https://github.com/nvm-sh/nvm.git .nvm

cd ~/.nvm || exit 1

LATEST_NVM_TAG=$(git describe --abbrev=0 --tags)

git checkout "$LATEST_NVM_TAG"

# shellcheck source=/dev/null
. ./nvm.sh

{
  echo "export NVM_DIR=\"$HOME/.nvm\""
  echo "[ -s $NVM_DIR/nvm.sh ] && \. $NVM_DIR/nvm.sh"
  echo "[ -s \"$NVM_DIR/bash_completion\" ] && \. \"$NVM_DIR/bash_completion\""
} >> $ZSH_PATH

printColors green "✋✋✋ setup script has finished ✋✋✋"
