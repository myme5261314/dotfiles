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

# Checkout to OS branch.
git checkout origin $platform:$platform

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
ln -s $root/vim/vimrc ~/.vimrc
ln -s $root/vim/vimrc ~/.gvimrc

echo "Install Spacemacs configurations..."
mv ~/.emacs.d ~/.emacs.d.old
mv ~/.spacemacs.d ~/.spacemacs.d.old
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
ln -s $root/spacemacs ~/.spacemacs.d

echo "Install zshrc configurations..."
if [[ "$platform" == "linux" ]]; then
    sudo apt-get install zsh-antigen
elif [[ "$platform" == "osx" ]]; then
    brew install antigen
    #source $(brew --prefix)/share/antigen/antigen.zsh
fi
ln -s $root/zshrc/.zshrc ~/.zshrc
