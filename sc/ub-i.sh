#!/data/data/com.termux/files/usr/bin/env bash

ARCH="`uname -m`"
OS="`uname -o`"

function ubuntu_install(){
    ubuntu_choice=$(whiptail --title "ntool-tui:container installer" --menu "选择一个以继续" 15 60 7 \
    "1" "Ubuntu20.04 Focal Fossa" \
    "2" "Ubuntu22.04 Jammy Jellyfish" \
    "3" "手动输入版本号" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 1 ];then
        ntool 
    fi 
    case $ubuntu_choice in
		00)
			ntool
			exit 0
			;;
		1)
			ver="20.04.5"
			break
			;;
		2)
			ver="22.04"
			break
			;;
	esac
    whiptail --title "ntool-tui:check" --yesno "你选择的版本:${ver} \
    你的系统:${OS} \
    你的架构:${ARCH} \
    请检查一下,否则可能出错" 15 60
	cd ~
	apt update
    apt upgrade
	apt install git tar zip unzip wget curl -y
    sleep 2
    echo "请耐心等待......"
	wget https://mirrors.bfsu.edu.cn/ubuntu-cdimage/ubuntu-base/releases/${version}/release/ubuntu-base-${version}-base-arm64.tar.gz
    mkdir -p ~/.ntool/ubuntu-fs
    mv ubuntu-base-${version}-base-arm64.tar.gz ~/.ntool/ubuntu-fs  
    cd ~/.ntool/ubuntu-fs
    tar -xvzf ubuntu-base-${version}-base-arm64.tar.gz
    set -e
    cd ~
    echo "nameserver 8.8.8.8"> /data/data/com.termux/files/home/.ntool/ubuntu-fs/etc/resolv.conf
    wget https://raw.githubusercontent.com/nnyyaa/ntool/main/sc/startubuntu
    mv ~/startubuntu $PREFIX/bin
    rm ~/.ntool/ubuntu-fs/ubuntu-base-${version}-base-arm64.tar.gz
    chmod 777 $PREFIX/bin/startubuntu
    echo "完成！"
    echo "输入 'startubuntu' 启动"
}
cd ~/.ntool
if [ ! -d ubuntu-fs ];then 
    if (whiptail --title "ntool-tui:WARNING" --yesno "你已经安装过Ubuntu了,你确定要再安装一次吗？" --defaultno 15 60);then
        ubuntu_install
    else
        ntool
        exit 0
    fi 
fi 
