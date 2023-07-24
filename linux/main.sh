#!/bin/bash

source "${NTOOLLIB}/linux/color_echo.sh"

GetPkgManager(){
    for i in pacman apt;do
        if (command -v ${i} > /dev/null 2>&1);then
            echo -e "${GREEN}找到包管理器:${i}.${RESET}"
            export PKGMANAGER="${i}"
        fi
    done
    case ${PKGMANAGER} in
        apt)
            alias PKGUP="apt update && sudo apt upgrade -y"
            alias PKGI="sudo apt install -y"
            alias PKGUNI="sudo apt purge"
            ;;
        pacman)
            alias PKGUP="sudo pacman -Syyu"
            alias PKGI="sudo pacman -S"
            alias PKGUNI="sudo pacman -R"
            ;;
        *)
            echo -e "${RED}未检测到适配的包管理器.(非pacman或apt)${RESET}"
            ;;
    esac
}

