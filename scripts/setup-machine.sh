#!/bin/bash
set -eo pipefail

# Make sure to load OS/Distro/etc variables
source "$HOME/.profile.local"
source "$HOME/dotfiles/scripts/helpers.sh"

if [ "$OS" == "Linux" ]; then
  if ! command -v apt-get > /dev/null; then
    echo "$XMARK Non-apt setup not supported"
    return 1
  fi

  # Make sure not to get stuck on any prompts
  export DEBIAN_FRONTEND=noninteractive
fi

# GUI-only packages
PACKAGES="$PACKAGES $(xargs < "$HOME/dotfiles/scripts/apt-packages")"


# Map git to correct remote
pushd "$HOME/dotfiles" > /dev/null
if ! git remote -v | grep -q -F "git@github.com"; then
  echo "$XMARK Dotfiles repo git remote not set"
  git remote set-url origin git@github.com:ayamnova/dotfiles.git
fi
echo "$CMARK Dotfiles repo git remote set"

popd > /dev/null

installAptPackagesIfMissing "$PACKAGES"
echo "$CMARK apt packages installed"

# Link missing dotfiles
("$HOME/dotfiles/scripts/link-dotfiles.sh" -f)

# Update source paths, etc
source ~/.profile
source ~/.bashrc

("$HOME/dotfiles/scripts/python-setup.sh")
("$HOME/dotfiles/scripts/node-setup.sh")
("$HOME/dotfiles/scripts/fzf-setup.sh")
("$HOME/dotfiles/scripts/nvim-setup.sh")
