#!/data/data/com.termux/files/usr/bin/env bash

cd ~/.ntool
if [ -d ubuntu-fs ];
then
	echo "看起来你可能安装过了"
	echo "重复安装会导致错误"
        echo "故终止该脚本运行"
        echo "如果需重新安装"
	echo "请手动执行: rm -rf ~/.ntool/ubuntu-fs $PREFIX/startubuntu"
	exit 0
else
        echo "请花一点时间，到百度搜索一下你所要安装的ubuntu的版本号"
        echo "输错将导致安装失败!"
        echo "推荐lts版本:22.04"
        echo "由于远程拉取sources.list易造成错误，故换源要您自行进行"
        echo "由于后面使用版本号来进行下载rootfs，故下方的版本号填写务必不可错"
	read -p "请输入正确的版本号(数字，带点)!:" version
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
        echo "nameserver 8.8.8.8" > /data/data/com.termux/files/home/.ntool/ubuntu-fs/etc/resolv.conf
        wget https://raw.githubusercontent.com/nnyyaa/ntool/main/startubuntu
        chmod +x startubuntu
        mv ~/startubuntu $PREFIX/bin
        echo "完成！"
        echo "输入 "startubuntu" 启动"
fi
