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
if [[ "$platform" == "linux" ]];then
    sudo apt-get update
    # Docker
    sudo apt-get install apt-transport-https ca-certificates
    sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    sudo echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list
    sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual
    # Apt-fast
    sudo add-apt-repository -y ppa:saiarcot895/myppa
    # Fasd
    sudo add-apt-repository -y ppa:aacebedo/fasd
    # Dropbox
    echo "deb http://linux.dropbox.com/ubuntu xenial main"|sudo tee /etc/apt/sources.list.d/dropbox.list
    sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E
    # Apt proxy
    sudo ln -sf $root/apt/01proxy /etc/apt/apt.conf.d/01proxy
    sudo apt-get update
    # Apt-fast
    sudo apt-get -y install apt-fast
    sudo apt-fast install -y aria2
    # Fasd
    sudo apt-fast install -y fasd
    # Docker
    sudo apt-fast install -y docker-engine
    sudo curl -L "https://github.com/docker/compose/releases/download/1.9.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo echo "DOCKER_OPTS=\"\$DOCKER_OPTS --registry-mirror=http://hub-mirror.c.163.com\"" >> /etc/default/docker
    cat /etc/default/docker | uniq | sudo tee /etc/default/docker
    # Source Code Pro.
    [ -d /usr/share/fonts/opentype ] || sudo mkdir /usr/share/fonts/opentype && sudo git clone --depth 1 --branch release https://github.com/adobe-fonts/source-code-pro.git /usr/share/fonts/opentype/scp && sudo fc-cache -f -v &
    sudo apt-fast install -y ctags
    sudo apt-fast install -y vim-gnome emacs
    sudo apt-fast install -y privoxy
    sudo apt-fast install -y proxychains
    mkdir ~/.proxychains
    ln -sf $root/proxychains.conf ~/.proxychians/proxychains.conf
    # Dropbox
    sudo apt-get install -y dropbox
    cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
    dropbox start
    ln -sf ~/Dropbox/org ~/org-notes
    sudo apt-fast install -y nodejs npm
    npm install -g cnpm --registry=https://registry.npm.taobao.org
    sudo apt-fast install -y pandoc
    sudo pip install jedi
    sudo apt-fast install -y supervisor
    sudo rm -rf /etc/supervisor/conf.d && sudo ln -sf $root/supervisor /etc/supervisor/conf.d
    ln -sf $root/aria2 ~/.aria2
    pkill -f "aria2c" && aria2c -D --conf-path=~/.aria2/aria2-chrome.conf
    mkdir ~/.config && ln -sf $root/autostart_ubuntu ~/.config/autostart
    # yapf
    sudo pip install yapf
elif [[ "$platform" == "osx" ]];then
    # Emacs.
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
    proxychains4 brew cask install dropbox
    ln -sf ~/Dropbox/org ~/org-notes
    brew install node
    npm install -g cnpm --registry=https://registry.npm.taobao.org
    brew install pandoc
    brew install fcitx-remote-for-osx
    pip install jedi
    # Supervisor
    brew install supervisor
    # echo_supervisord_conf > /usr/local/etc/supervisord.conf
    ln -sf $root/supervisor /usr/local/etc/supervisor.d
    # aria2-yaaw backend by supervisor.
    ln -sf $root/aria2 ~/.aria2

    # RescueTime
    brew cask install rescuetime
    # Doxymacs
    brew install doxymacs
    # Virtualbox
    brew cask install virtualbox

    # yapf
    pip install yapf
fi

# Checkout to OS branch.
git fetch origin $platform:$platform

# Pull all submodules.
git submodule init
git submodule update

echo "Install vim configurations..."

echo "clear .vim directory"
#rm -rf ~/.vim
echo "Install Vundle for vim."
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim


echo "link .vimrc"
rm ~/.vimrc
rm ~/.gvimrc
ln -s $root/vim/.vimrc ~/.vimrc
ln -s $root/vim/.vimrc ~/.gvimrc
nohup vim +BundleUpdate &

echo "Install Spacemacs configurations..."
#mv -f ~/.emacs.d ~/.emacs.d.old
#mv -f ~/.spacemacs.d ~/.spacemacs.d.old
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
cd ~/.emacs.d && git checkout develop && cd $root
ln -s $root/spacemacs ~/.spacemacs.d

echo "Install zshrc configurations..."
if [[ "$platform" == "linux" ]]; then
    sudo apt-fast install -y global
    sudo apt-fast install -y zsh-antigen
elif [[ "$platform" == "osx" ]]; then
    brew install antigen
fi
ln -s $root/zshrc/.zshrc ~/.zshrc


echo "Install TheFuck..."
if [[ "$platform" == "linux" ]]; then
    sudo apt-fast install -y zsh-antigen
    chsh -s /usr/bin/zsh
    sudo apt-fast install -y python3-dev python3-pip
    sudo -H pip3 install thefuck
elif [[ "$platform" == "osx" ]]; then
    brew install thefuck
fi

# Pip configuration.
mkdir ~/.pip
ln -sf $root/pip.conf ~/.pip/pip.conf
