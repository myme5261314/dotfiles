#!/bin/bash

# install depency software
# install homebrew
# ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
# install tmux
# brew install tmux
#install git 
#brew install git

root=`pwd`

# Check OS.
platform="unknown"
unamestr=`uname`
if [[ "$unamestr" == "Linux" ]]; then
   platform="linux"
elif [[ "$unamestr" == "Darwin" ]]; then
   platform="osx"
fi

# Pre dependencies install.
if [[ "$platform" == "Linux" ]];then
    # Useless.
    sudo apt-get install source-code-pro
elif [[ "$platform" == "osx" ]];then
    brew tap caskroom/fonts
    brew cask install font-source-code-pro
    brew install ctags
    brew update
    brew install macvim --with-lua --with-override-system-vim
    brew linkapps macvim
    brew install xz cmake
    xcode-select --install
    brew install fasd
    brew install privoxy
    echo "\nactionsfile wall.action\n" >> /usr/local/etc/privoxy/config
    ln -s $root/wall.action /usr/local/etc/privoxy/wall.action
    brew services start privoxy
    brew install proxychains-ng
    mkdir ~/.proxychains
    ln -sf $root/proxychains.conf ~/.proxychians/proxychains.conf
    brew install node
    npm install -g cnpm --registry=https://registry.npm.taobao.org
    brew install pandoc
    brew install fcitx-remote-for-osx
    pip install jedi
    # Supervisor
    brew install supervisor
    # echo_supervisord_conf > /usr/local/etc/supervisord.conf
    ln -sf $root/supervisor /usr/local/etc/supervisor.d

fi

# Checkout to OS branch.
git fetch origin $platform:$platform

# Pull all submodules.
git submodule init
git submodule update

echo "Install vim configurations..."

echo "clear .vim directory"
rm -rf ~/.vim
echo "Install Vundle for vim."
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim


echo "link .vimrc"
rm ~/.vimrc
rm ~/.gvimrc
ln -s $root/vim/.vimrc ~/.vimrc
ln -s $root/vim/.vimrc ~/.gvimrc

echo "Install Spacemacs configurations..."
mv -f ~/.emacs.d ~/.emacs.d.old
mv -f ~/.spacemacs.d ~/.spacemacs.d.old
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
cd ~/.emacs.d && git checkout develop && cd $root
ln -s $root/spacemacs ~/.spacemacs.d

echo "Install zshrc configurations..."
if [[ "$platform" == "linux" ]]; then
    sudo apt-get install zsh-antigen
elif [[ "$platform" == "osx" ]]; then
    brew install antigen
fi
ln -s $root/zshrc/.zshrc ~/.zshrc


echo "Install TheFuck..."
if [[ "$platform" == "linux" ]]; then
    sudo apt-get install zsh-antigen
    sudo apt update
    sudo apt install python3-dev python3-pip
    sudo -H pip3 install thefuck
elif [[ "$platform" == "osx" ]]; then
    brew install thefuck
fi

# Pip configuration.
mkdir ~/.pip
ln -s $root/pip.conf ~/.pip/pip.conf
