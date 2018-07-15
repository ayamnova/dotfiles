#Originally written by another user
#Modified by Karsten Ladner, 2/11/2018

#!/bin/sh
DOTFILESREPO="https://github.com/ayamnova/dotfiles.git"
set -ef

CMARK='✓'
XMARK='✖'
if [ -t 1 ]; then
  # Use colors in terminal
  CMARK="$(tput setaf 2)$CMARK$(tput sgr0)"
  XMARK="$(tput setaf 1)$XMARK$(tput sgr0)"
fi

# Auto-detect as much as possible about the system to make the correct
# assumptions about what should be installed
ARCH=$(uname -m)
OS=$(uname)

if [ "$OS" = "Linux" ]; then
  # Distinguish betweent Debian & Ubuntu
  if command -v apt-get > /dev/null; then
    # Must have lsb_release installed for Debian/Ubuntu beforehand. Seems
    # to come on EC2 images, but not in chromebook chroots.
    #lsb-release detects what kind of OS the computer is running
    if ! command -v lsb_release > /dev/null; then
      echo "Installing lsb-release (requires sudo)"
      sudo apt-get -qqfuy install lsb-release
    fi

    if lsb_release -d | grep -iq "ubuntu"; then
      DISTRO="Ubuntu"
    else
      # TODO: There are other debian-based distros, consider detecting?
      DISTRO="Debian"
    fi
    VERSION=$(lsb_release -s -c)
  else
    # Haven't bothered using other distros yet
    # When using other Distros, add that here
    DISTRO="Unknown"
    VERSION="Unknown"
  fi
else
  # What strange machine is this running on?
  DISTRO="Unknown"
  VERSION="Unknown"
fi

# Write variables to file
LOCAL_PROFILE="$HOME/.profile.local"
if [ ! -f "$LOCAL_PROFILE" ]; then
  {
    echo "# Generated $(date +%F)"
    echo "export ARCH=$ARCH"
    echo "export OS=$OS"
    echo "export DISTRO=$DISTRO"
    echo "export VERSION=$VERSION"

    #Throwing in some default values so that nothing
    #will break (hopefully)
    echo "export IS_CROUTON=0"
    echo "export IS_DOCKER=0"
    echo "export IS_EC2=0"
    echo "export IS_HEADLESS=0"
    echo ""
    echo "# Add machine-specific items below"
    echo "# export LAST_FM_USERNAME=xxx"
    echo "# export LAST_FM_PASSWORD=xxx"
    echo "# etc ..."
  } > "$LOCAL_PROFILE"

  echo "$CMARK Config file written to $LOCAL_PROFILE:"
  . "$LOCAL_PROFILE"
else
  echo "$CMARK $LOCAL_PROFILE already exists"
fi
unset LOCAL_PROFILE

DOTFILES="$HOME/dotfiles"

# First, we need to make sure we have the bare minimums to install things on
# this system
if [ "$OS" = "Linux" ] && command -v apt-get > /dev/null; then
  # Don't want installs to wait on user interaction
  export DEBIAN_FRONTEND=noninteractive

  if ! command -v add-apt-repository > /dev/null; then
    echo "Installing software-properties-common (requires sudo)"
    sudo apt-get -qqfuy install software-properties-common
  fi

  if [ "$DISTRO" = "Debian" ]; then
    echo "Adding contrib & non-free to sources (requires sudo)"
    sudo add-apt-repository -y contrib > /dev/null
    sudo add-apt-repository -y non-free > /dev/null
  elif [ "$DISTRO" = "Ubuntu" ]; then
    echo "Adding restricted, universe, and multiverse to sources (requires sudo)"
    sudo add-apt-repository -y restricted > /dev/null
    sudo add-apt-repository -y universe > /dev/null
    sudo add-apt-repository -y multiverse > /dev/null
  fi

  # Make sure git is in there
  if ! command -v git > /dev/null; then
    echo "Installing git (requires sudo)..."
    # If git isn't here, then this is the first time running, likely need to
    # update all sources
    sudo apt-get -qq update
    sudo apt-get -qqfuy install git
  fi
  echo "$CMARK Git installed"
else
  echo "$XMARK Sorry, but your system ($OS) is not supported"
  exit 1
fi

# Pull down the full repo
if [ ! -d "$DOTFILES" ]; then
  echo "Cloning dotfiles repo to $DOTFILES"
  git clone "$DOTFILESREPO" "$DOTFILES" > /dev/null
else
  echo "Pulling latest dotfiles..."
  (cd "$DOTFILES"; git pull 2> /dev/null || true)
fi
echo "$CMARK ~/dotfiles present"

# Now run the main setup now that we have the repo, etc
. "$HOME/dotfiles/scripts/setup-machine.sh"
