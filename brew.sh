#!/usr/bin/env bash

brewIn() {
    if brew ls --versions "$1"; then
        brew upgrade "$1";
    else
        brew install "$1";
    fi
}

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing Homebrew ..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
echo "Update Homebrew recipes ..."
brew update

# Upgrade any already-installed formulae.
echo "Upgrade any already-installed formulae ..."
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install Brew Packages
PACKAGES=(
    ack
    awscli
    autoconf
    automake
    bash
    bash-completion2
    bfg
    bower
    composer
    curl
    dockutil
    dnsmasq
    ffmpeg
    findutils
    geoip
    git
    git-lfs
    gmp
    gnu-sed --with-default-names
    gnupg
    grep
    grunt-cli
    htop
    httpd
    imagemagick --with-webp
    libiconv
    lynx
    jq
    mailhog
    mariadb
    moreutils
    ncdu
    npm
    nvm
    openssh
    php
    php-cs-fixer
    php@7.1
    php@7.2
    php@7.3
    php@7.4
    python
    python3
    screen
    speedtest-cli
    ssh-copy-id
    terminal-notifier
    tldr
    tree
    vim --with-override-system-vi
    wget --with-iri
    wp-cli
    yarn
    zsh
    zsh-completions
    zsh-syntax-highlighting
)

echo "Installing Homebrew packages..."
for i in "${PACKAGES[@]}"; do
  echo "Installing $i"
  brewIn "$i"
done

# Install Applications
CASKS=(
    1password
    1password-cli
    adobe-acrobat-reader
    appcleaner
    avast-security
    brave-browser
    diffmerge
    docker
    figma
    firefox
    flux
    fontbase
    franz
    google-chrome
    google-drive
    google-hangouts
    google-trends
    grammarly
    iina
    imageoptim
    iterm2
    jira-client
    maccy
    microsoft-edge
    mutespotifyads
    nordvpn
    postman
    rectangle
    sequel-pro
    slack
    sourcetree
    spark
    spotify
    the-unarchiver
    transmit
    visual-studio-code
    zoomus
)

echo "Installing cask apps..."
for i in "${CASKS[@]}"; do
  echo "Installing $i"
  brew cask install --force "$i"
done

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

# Install fonts
echo "Installing fonts..."
brew tap homebrew/cask-fonts
FONTS=(
    font-fira-code
    font-roboto
)

for i in "${FONTS[@]}"; do
  echo "Installing $i"
  brew cask install "$i"
done

# Remove outdated versions from the cellar.
brew cleanup

echo "Generate SSH Key ..."
cat /dev/zero | ssh-keygen -t rsa -b 4096 -C "$email" -q -N "" > /dev/null

echo "Installing Node.js v8 ..."
mkdir ~/.nvm
sudo nvm install 8

echo "Installing Node.js v10 ..."
sudo nvm install 10

echo "Installing latest Node.js ..."
sudo nvm install --lts
# make sure we are using the latest version
sudo nvm use --silent --lts

echo "Installing Gulp ..."
sudo npm install --silent --global gulp-cli > /dev/null

echo "Installing Grunt ..."
sudo npm install --silent --global grunt-cli > /dev/null

echo "Installing Gatsby CLI ..."
sudo npm install --silent --global gatsby-cli > /dev/null

echo "Set ZSH as the default shell ..."
chsh -s /bin/zsh

echo "Copying Zsh configuration ..."
cp -r .zshrc ~/.zshrc 2> /dev/null
