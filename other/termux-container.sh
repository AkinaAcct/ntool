#!/usr/bin/env bash
#from https://github.com/moe-hacker/termux-container

install_termux-container() {
    echo "please wait..."
    pkg install -y make
    git clone https://github.com/moe-hacker/termux-container ~/termux-container
    cd ~/termux-container || exit 1
    make && make install
}
