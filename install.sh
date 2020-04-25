#!/bin/bash

# Utils
function is_installed {
  # set to 1 initially
  local return_=1
  # set to 0 if not found
  type $1 >/dev/null 2>&1 || { local return_=0;  }
  # return
  echo "$return_"
}

function install_macos {
  if [[ $OSTYPE != darwin* ]]; then
    return
  fi
  echo "MacOS detected"
  #xcode-select --install

  if [ "$(is_installed brew)" == "0" ]; then
    echo "Installing Homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  if [ $TERM_PROGRAM != "iTerm.app" ]; then
    echo "Installing iTerm2"
    brew tap caskroom/cask
    brew cask install iterm2
  fi

  if [ "$(is_installed zsh)" == "0" ]; then
    echo "Installing zsh"
    brew install zsh zsh-completions
  fi

  if [ "$(is_installed tmux)" == "0" ]; then
    echo "Installing tmux"
    brew install tmux
    echo "Installing reattach-to-user-namespace"
    brew install reattach-to-user-namespace
    echo "Installing tmux-plugin-manager"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi

  if [ "$(is_installed git)" == "0" ]; then
    echo "Installing Git"
    brew install git
  fi
}

function backup {
  echo "Backing up dotfiles"
  local current_date=$(date +%s)
  local backup_dir=dotfiles_$current_date

  mkdir ~/$backup_dir

  mv ~/.zshrc ~/$backup_dir/.zshrc
  mv ~/.tmux.conf ~/$backup_dir/.tmux.conf
}

function link_dotfiles {
  echo "Linking dotfiles"
  mv ~/.zshrc ~/.zshrc.backup
  ln -s $(pwd)/zshrc ~/.zshrc
  ln -s $(pwd)/tmux.conf ~/.tmux.conf

  echo "Installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

  if [ ! -d "$ZSH/custom/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions"
    git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH/custom/plugins/zsh-autosuggestions
  fi
}

while test $# -gt 0; do 
  case "$1" in
    --help)
      echo "Help"
      exit
      ;;
    --macos)
      install_macos
      backup
      link_dotfiles
      zsh
      source ~/.zshrc
      exit
      ;;
    --backup)
      backup
      exit
      ;;
    --dotfiles)
      link_dotfiles
      exit
      ;;
  esac

  shift
done