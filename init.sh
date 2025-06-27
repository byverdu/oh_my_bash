#!/bin/bash

HOST_NAME=$(hostname | cut -d"." -f1)

printColors() {
  case "$1" in
  "red") echo -e "\033[1;31m$2\033[0m" ;;
  "green") echo -e "\033[1;32m$2\033[0m" ;;
  "orange") echo -e "\033[1;33m$2\033[0m" ;;
  *) echo "$2" ;;
  esac
}

read -r -p "Do you want to install Xcode Command Line Tools? (y/n)" xcodeTools

if [[ "$xcodeTools" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
  printColors green "🤘 Installing Xcode Command Line Tools.... 🤘"
  xcode-select --install
else
  printColors orange "Skipping Xcode Command Line Tools"
fi

read -r -p "Do you want to Homebrew? (y/n)" homebrew

if [[ "$homebrew" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
  printColors green "🤘 Installing Homebrew.... 🤘"
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  printColors orange "adding Homebrew to PATH"

  echo >> "/Users/$HOST_NAME/.zprofile" || exit 1
  echo "eval $(/opt/homebrew/bin/brew shellenv)" >> "/Users/$HOST_NAME/.zprofile"
  eval "$(/opt/homebrew/bin/brew shellenv)"

else
  printColors orange "Skipping Homebrew"
fi

read -r -p "Do you want to show all hidden files? (y/n)" hiddenFiles

if [[ "$hiddenFiles" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
  printColors green "🤘 Showing all hidden files.... 🤘"
   defaults write com.apple.Finder AppleShowAllFiles true
   killall Finder 
else
  printColors orange "Skipping Homebrew"
fi

chmod +x custom.sh
chmod +x setup.sh
touch ~/.zshrc

# shellcheck source=/dev/null
source custom.sh
# shellcheck source=/dev/null
source setup.sh

setup.sh || printColors red "Setup script failed to execute"
