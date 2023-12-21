#!/usr/bin/env bash
#Started at 2023-12-09 01:29:04
#Finished at 2023-12-09 02:00:59
#by nya
#自动处理chroot容器的fakeroot问题
#
#################################
#       BEGIN OF SCRIPT         #
#################################

DOWNURL="http://ftp.cn.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.32.2.orig.tar.gz"
SOLVERTMP="/tmp/nya_archfakeroot_solver"

#检测命令
sudo pacman -Syu
for i in wget tar make glibc filesystem sed util-linux po4a automake autoconf acl git; do
	if ! (command -v ${i} >/dev/null); then
		echo "软件${i}未找到！安装中……"
		sudo pacman -S ${i} --overwrite "*" --noconfirm
	fi
done

if [[ "${1}" == "-h" || "${1}" == "--help" ]]; then
	echo -e "简单的./运行就可以了！"
	exit 0
fi

#获取源码
echo "获取源码"
mkdir ${SOLVERTMP} -p || exit 1
wget ${DOWNURL} -O ${SOLVERTMP}/fr.tgz || exit 1
cd ${SOLVERTMP} || exit 1
tar xvf fr.tgz || exit 1

#编译临时fakeroot
echo "编译临时fakeroot"
cd ${SOLVERTMP}/fakeroot*/ || exit 1
./bootstrap
./configure --prefix=${SOLVERTMP} --libdir=${SOLVERTMP}/fakeroot/libs --disable-static --with-ipc=tcp
make -j$(nproc)
sudo make install

#创建临时软链接
echo "创建临时软链接"
ln -s ${SOLVERTMP}/bin/fakeroot /usr/bin/
ln -s ${SOLVERTMP}/bin/faked /usr/bin/

#克隆fakeroot-tcp源码
echo "克隆fakeroot-tcp源码"
git clone https://aur.archlinux.org/fakeroot-tcp.git

#构建PKG
echo "构建PKG"
cd fakeroot-tcp || exit 1
makepkg

#安装fakeroot-tcp
echo "安装fakeroot-tcp"
sudo pacman -U --overwrite "*" fakeroot*.pkg.tar.xz
rm -rf ${SOLVERTMP}

#################################
#         END OF SCRIPT         #
#################################
