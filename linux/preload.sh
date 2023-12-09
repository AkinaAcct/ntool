#!/usr/bin/env bash
#字体颜色
BLACK="\e[30m"  #黑色
RED="\e[31m"    #红色
GREEN="\e[32m"  #绿色
YELLOW="\e[33m" #黄色
BLUE="\e[34m"   #蓝色
PURPLE="\e[35m" #紫色
CYAN="\e[36m"   #青色
WHITE="\e[37m"  #白色

RESET="\e[0m" #颜色重设

NTOOLLIB="${HOME}/.local/ntool"

# GetPkgManager
for i in pacman apt; do
	if (command -v ${i} >/dev/null 2>&1); then
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

source "${NTOOLLIB}/linux/main.sh"

echo -e "[$(date "+%Y-%m-%d %H:%M:%S.%N")] EXECUTE:/linux/preload.sh" >>${NTOOLLIB}/log.txt
