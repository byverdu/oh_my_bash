#!/bin/bash

HOST_NAME=$(hostname | cut -d"." -f1)
ZSH_PATH=~/.zshrc
# shellcheck source=/dev/null
source "/Users/$HOST_NAME/Projects/repos/oh_my_bash/custom.sh"

printColors green "🤘 Setting github info.... 🤘"

git config --global user.email "byverdu@gmail.com"
git config --global user.name "Albert Vallverdu"

# Installing dependencies through brew
printColors green "🤘 Installing brew casks applications.... 🤘"

# Mac applications
brew install --cask raycast
brew install --cask betterdisplay
brew install --cask logi-options+
brew install --cask runjs
brew install --cask claude

# Browsers
brew install --cask helium-browser
brew install --cask google-chrome
brew install --cask firefox-developer-edition
brew install --cask brave-browser

# Terminals
# install https://github.com/en3sis/figxit
# install https://atuin.sh/
brew install --cask ghostty
brew install --cask iterm2

# Text editors
brew install --cask visual-studio-code@insiders
brew install --cask visual-studio-code
brew install --cask cursor
brew install --cask zed@preview
brew install --cask zed
brew install --cask jetbrains-toolbox

# Dev tools
brew install --cask postman
brew install --cask docker
brew install --cask expressvpn

# MSG apps
brew install --cask microsoft-teams
brew install --cask microsoft-outlook
brew install --cask whatsapp
brew install --cask slack

# Databases
brew install --cask robo-3t
brew install --cask studio-3t

# Home apps
brew install --cask plex-media-server
brew install --cask transmission
brew install --cask dropbox
brew install --cask vlc

printColors green "🤘 Installing fonts.... 🤘"

brew install --cask font-fira-code
brew install --cask font-jetbrains-mono # Install manually from https://www.jetbrains.com/lp/mono/
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
brew install zsh-syntax-highlighting
brew install zsh-autosuggestions
brew install fnm # Fast Node Manager
brew install zoxide # easier than cd as it remembers navigated folders. Nice integration with kiro-cli
brew install fzf # to search files

# Allow install plugins in vim
# Remember to move .vimrc file into ~ home directory
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

{
  echo "# Custom config"
  echo "export GLOBAL_PATH=/Users/$HOST_NAME/Projects"
  echo "source ~/Projects/repos/oh_my_bash/custom.sh"
  echo "source ~/Projects/repos/oh_my_bash/prompt.sh"
  echo "source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  echo "source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  echo "export BAT_THEME=\"Catppuccin Mocha\""
  # shellcheck disable=SC2016
  echo 'eval "$(fnm env --use-on-cd --shell zsh)"'
  echo 'eval "$(zoxide init zsh)"'
} >> $ZSH_PATH

# printColors green "🤘 NVM setup 🤘"

# echo "# NVM config" >> $ZSH_PATH

# cd ~ || exit 1

# git clone https://github.com/nvm-sh/nvm.git .nvm

# cd ~/.nvm || exit 1

# LATEST_NVM_TAG=$(git describe --abbrev=0 --tags)

# git checkout "$LATEST_NVM_TAG"

# # shellcheck source=/dev/null
# . ./nvm.sh

# {
#   echo "export NVM_DIR=\"$HOME/.nvm\""
#   echo "[ -s $NVM_DIR/nvm.sh ] && \. $NVM_DIR/nvm.sh"
#   echo "[ -s \"$NVM_DIR/bash_completion\" ] && \. \"$NVM_DIR/bash_completion\""
# } >> $ZSH_PATH

# install https://atuin.sh/ ctrl + r back search replacement
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

printColors green "✋✋✋ setup script has finished ✋✋✋"
