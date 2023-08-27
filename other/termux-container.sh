#!/bin/bash
#from https://github.com/moe-hacker/termux-container

install_termux-container() {
    echo "please wait..."
    pkg i -y make
    git clone https://github.com/moe-hacker/termux-container ~/termux-container
    cd ~/termux-container || exit 1
    make
    apt install -f ./termux-container.deb
}
