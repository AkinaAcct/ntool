#!/data/data/com.termux/files/usr/bin/env bash

cd ~/.ntool
if [ -d "ubuntu-fs" ];
then
	echo "看起来你可能安装过了"
	echo "重复安装会导致错误"
        echo "故终止该脚本运行"
        echo "如果需重新安装"
	echo "请手动执行: rm -rf ~/.ntool/ubuntu-fs $PREFIX/startubuntu"
	exit 0
else
	while true
	do
	echo "注意：现只支持安装单个容器"
	echo "无法同时安装多个同系统容器"
        echo "推荐lts版本:22.04"
	echo "1. 20.04"
	echo "2. 21.10"
	echo "3. 22.04(推荐)"
	read -p "输入你的选择: " answer
	case $answer in
		1)
			version="20.04.5"
			break
			;;
		2)
			version="21.10"
			break
			;;
		3)
			version="22.04"
			break
			;;
		*)
			echo "未知选择，请确认输入无误"
			sleep 2
			;;
	esac
	done
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
        wget https://raw.githubusercontent.com/nnyyaa/ntool/main/startubuntu
        cd ubuntu-fs/etc
        echo "echo 'nameserver 8.8.8.8' > /etc/resolv.conf" > /data/data/com.termux/files/home/.ntool/ubuntu-fs/etc/bash.bashrc
        wget https://raw.githubusercontent.com/nnyyaa/ntool/main/startubuntu
        chmod +x startubuntu
        mv ~/startubuntu $PREFIX/bin
        echo "完成！"
        echo "输入 "startubuntu" 启动"
fi
