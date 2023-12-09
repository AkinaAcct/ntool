#!/usr/bin/env bash
#Started at 2023-12-09 01:29:04
#Finished at 2023-12-09 02:00:59
#by nya
#自动处理chroot容器的fakeroot问题
#################################
#       BEGIN OF SCRIPT         #
#################################

DOWNURL="http://ftp.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.25.3.orig.tar.gz"
SOLVERTMP="/tmp/nya_archfakeroot_solver"

#检测命令
for i in wget tar make; do
	if ! (command -v ${i} >/dev/null); then
		sudo pacman -Sy ${i} --overwrite "*" --noconfirm
	fi
done

if [[ "${1}" == "-h" || "${1}" == "--help" ]]; then
	echo -e "简单的./运行就可以了！"
	exit 0
fi

#获取源码
mkdir ${SOLVERTMP} -p
wget ${DOWNURL} -O ${SOLVERTMP}/fr.tgz || echo "Download failed.Check your network please." && exit 1
tar xvf ${SOLVERTMP}/fr.tgz -C ${SOLVERTMP} || echo "Uncompress failed.Please re-run this script." && exit 1

#编译临时fakeroot
cd ${SOLVERTMP}/fakeroot-1.25.3/ || exit 1
./bootstrap
./configure --prefix=${SOLVERTMP} --libdir=${SOLVERTMP}/fakeroot/libs --disable-static --with-ipc=tcp
make -j"$(nproc)"
sudo make install

#创建临时软链接
ln -s ${SOLVERTMP}/bin/fakeroot /usr/bin/
ln -s ${SOLVERTMP}/bin/faked /usr/bin/

#克隆fakeroot-tcp源码
git clone https://aur.archlinux.org/fakeroot-tcp.git

#构建PKG
cd fakeroot-tcp || exit 1
makepkg

#安装fakeroot-tcp
rm -rf ${SOLVERTMP}
sudo pacman -U --overwrite "*" fakeroot*.pkg.tar.xz

#################################
#         END OF SCRIPT         #
#################################
