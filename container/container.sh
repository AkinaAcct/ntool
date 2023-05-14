container_testing_tui(){
    dialog --title "ntool-tui:按ESC返回上一页" --yes-label "proot" --no-label "chroot" --yesno "选择一个\nchroot需要root,运行速度较快\nproot无需root,但运行速度较慢" 15 70
    EXITSTATUS=$?
    case ${EXITSTATUS} in
        0)
            CONTAINERPOR="PROOT" #CONTAINER PROOT OR CHROOT
            ;;
        1)
            CONTAINERPOR="CHROOT" #CONTAINER PROOT OR CHROOT 
            ;;
        255)
            container_tui
            ;;
    esac
    LINUXNAME=$(dialog --output-fd 1 --title "ntool-tui:testing function" --inputbox "你在使用一个测试功能\n输入Linux发行版名称" 15 70)
    LINUXVER=$(dialog --output-fd 1 --title "ntool-tui:testing function" --inputbox "你在使用一个测试功能\n输入发行版版本" 15 70)
    LINUXPATH=$(dialog --output-fd 1 --title "ntool-tui:testing function" --inputbox "你在使用一个测试功能\n输入安装路径" 15 70)
    if [ -z ${LINUXNAME} ]||[ -z ${LINUXVER} ]||[ -z ${LINUXPATH} ];then
        bad_empty_input
        container_testing_tui
    else
        echo -e "${GREEN}正在从BFSU镜像站获取rootfs地址...${RESET}"
        ROOTFSTIME=$(curl https://mirrors.bfsu.edu.cn/lxc-images/images/${LINUXNAME}/${LINUXVER}/${ARCH}/default/ 2> /dev/null | gawk '{print $3}' | tail -n 3 | head -n 1 | gawk -F '"' '{print $2}' | gawk -F '/' '{print $1}')
        echo -e "${GREEN}检测获取的地址是否正确...${RESET}"
        if [ -z ${ROOTFSTIME} ];then
            echo -e "${RED}"
            read -p  "获取到了错误的rootfs地址!按回车重新输入信息!"
            echo -e "${RESET}"
            container_testing_tui
        else
            echo -e "${GREEN}开始下载...${RESET}"
            if [ -f ${MAINPATH}/rootfs/${LINUXNAME}-${LINUXVER}.tar.xz ];then
                rm ${MAINPATH}/rootfs/${LINUXNAME}-${LINUXVER}.tar.xz
            fi
            wget https://mirrors.bfsu.edu.cn/lxc-images/images/${LINUXNAME}/${LINUXVER}/${ARCH}/default/${ROOTFSTIME}/rootfs.tar.xz -O ${MAINPATH}/rootfs/${LINUXNAME}-${LINUXVER}.tar.xz
            download_check
            EXITSTATUS=$?
            if [ ${EXITSTATUS} = 1 ];then
                rm ${MAINPATH}/rootfs/${LINUXNAME}-${LINUXVER}.tar.xz
                container_testing_tui
            fi
            echo -e "${GREEN}下载完成!解压中...${RESET}"
            mkdir -p ${LINUXPATH}
            tar -xvf ${MAINPATH}/rootfs/${LINUXNAME}-${LINUXVER}.tar.xz -C ${LINUXPATH}
            case ${CONTAINERPOR} in
                PROOT)
                    write_groupadd_sh
                    write_setupdeb_sh
                    container_script_write
                    read -p "完成了!输入start${LINUXVER}启动"
                    exit 0
                    ;;
                CHROOT)
                    wait_for_dev_tui
                    exit 1
                    ;;
            esac
            echo -e "${GREEN}完成${RESET}"
        fi
    fi
}

container_tui(){      #容器OS选择
    CONTAINER_CHOICE=$(dialog --output-fd 1 --title "ntool-tui:container installer" --menu "选择一个以继续" 15 70 8 \
    "1" "Ubuntu 我的存在是因为大家的存在" \
    "2" "Debian 为爱发电,爱的结晶" \
    "3" "使用测试中的新容器安装脚本" \
    "0" "返回上一页")       #我是鸽子咕咕咕，其他功能等我慢慢写
    EXITSTATUS=$?
    if [ $EXITSTATUS != 0 ];then
        termux_main_tui
    fi
    case $CONTAINER_CHOICE in
        0)
            termux_main_tui
            ;;
        1)
            CONTAINER_OS=ubuntu
            ubuntu_version_tui
            ;;
        2)
            CONTAINER_OS=debian
            debian_version_tui
            ;;
        3)
            container_testing_tui
            ;;
    esac
}

debian_version_tui(){     #Debian版本选择
    DEBIAN_VER_CHOICE=$(dialog --output-fd 1 --title "ntool-tui:Debian Version" --menu "选择一个以继续 \n同版本不可二次安装，不同版本可以哦" 15 70 8 \
    "1" "Debian10 Buster" \
    "2" "Debian11 Bullseye" \
    "0" "返回上一页")
    EXITSTATUS=$?
    if [ $EXITSTATUS != 0 ];then
        container_tui
    fi
    case $DEBIAN_VER_CHOICE in
        0)
            container_tui
            ;;
        1)
            VERCODE="10"
            VERNAME="buster"
            ;;
        2)
            VERCODE="11"
            VERNAME="bullseye"
            ;;
    esac
    container_control_tui
}

ubuntu_version_tui(){     #Ubuntu版本选择
    cd ${MAINPATH}
    UBUNTU_VER_CHOICE=$(dialog --output-fd 1 --title "ntool-tui:Ubuntu Version" --menu "选择一个以继续\n同版本不可二次安装，不同版本可以哦" 15 70 8 \
    "1" "Ubuntu22.04 Jammy Jellyfish" \
    "2" "Ubuntu20.04 Focal Fossa" \
    "0" "返回上一页")
    EXITSTATUS=$?
    if [ $EXITSTATUS != 0 ];then
        container_tui
    fi
    case ${UBUNTU_VER_CHOICE} in 
        0)
            container_tui
            ;;
        1)
            VERCODE="22.04"
            VERNAME="jammy"
            ;;
        2)
            VERCODE="20.04"
            VERNAME="focal"
            ;;
    esac
    container_control_tui
}

container_control_tui(){
    CCPAGECHOICE=$(dialog --output-fd 1 --title "ntool-tui:container control" --menu "${CONTAINER_OS}${VERCODE} ${VERNAME}管理页面 \n选择一个以继续" 15 70 8 \
    "1" "安装" \
    "2" "卸载" \
    "0" "返回上一页")
    EXITSTATUS=$?
    if [ $EXITSTATUS != 0 ];then
        ${CONTAINER_OS}_version_tui
    fi
    case $CCPAGECHOICE in
        0)
            ${CONTAINER_OS}_version_tui
            ;;
        1)
            if [ -d ${CONTAINER_OS}-${VERNAME} ];then
                dialog --title "ntool-tui:WARNING" --msgbox "不允许的二次安装" 15 70
                container_control_tui
            fi
            container_install
            exit 0
            ;;
        2)
            if [ ! -d ${CONTAINER_OS}-${VERNAME} ];then
                dialog --title "ntool-tui:WARNING" --msgbox "你还没有安装这个容器" 15 70
                container_control_tui
            fi
            dialog --title "ntool-tui:WARNING" --defaultno --yesno "警告！\n这会删除你在容器里的全部数据\n如果你不知道你在干什么，请取消" 15 70
            EXITSTATUS=$?
            if [ $EXITSTATUS != 0 ];then
                container_control_tui
                exit 0
            fi
            container_delete
            exit 0
            ;;
    esac
}

function container_delete(){
    rm -rvf ${MAINPATH}/${CONTAINER_OS}-${VERNAME}
    rm -v $PREFIX/bin/start${VERNAME}
    dialog --title "ntool-tui:success" --msgbox "删除完成" 15 70
    container_tui
}

function container_script_write(){
echo -e "${GREEN}写入启动脚本中${RESET}"
cat > $PREFIX/bin/start${VERNAME} <<- EOF
#!/data/data/com.termux/files/usr/bin/bash
#ntool ${CONTAINER_OS}${VERCODE}:${VERNAME}启动脚本
#嗯...复制也是可以的啦...我不在意...
#毕竟这东西没什么技术含量的啦...
cd ~/.ntool
unset LD_PRELOAD
COMMAND="proot"
COMMAND+=" --link2symlink"
COMMAND+=" -0"
COMMAND+=" -r ${CONTAINER_OS}-${VERNAME}"
COMMAND+=" -b /dev"
COMMAND+=" -b /sys"
COMMAND+=" -b /proc"
#不建议直接挂载sdcard
#有隐私问题
#COMMAND+=" -b /sdcard"
#默认不挂载本机目录
#下面一行为仅挂载termux里的HOME(默认注释)
#COMMAND+=" -b /data/data/com.termux/files/home:/root"
COMMAND+=" -w /root"
COMMAND+=" /usr/bin/env -i"
COMMAND+=" HOME=/root"
COMMAND+=" PATH=/usr//sbin:/usr//bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr//games"
COMMAND+=" TERM=xterm-256color"
COMMAND+=" LANG=C.UTF-8"
COMMAND+=" /bin/bash -l"
EOF
echo 'exec $COMMAND' >> ${PREFIX}/bin/start${VERNAME}
chmod +x ${PREFIX}/bin/start${LINUXVER}
}

function write_groupadd_sh(){
echo -e "${GREEN}添加用户组中...${RESET}"
cat > ${MAINPATH}/${CONTAINER_OS}-${VERNAME}/root/groupadd.sh <<- EOF
groupadd -g 3003 inet
groupadd -g 9997 everybody
groupadd -g 20123 u0_a123_cache
groupadd -g 50123 all_a123
groupadd -g 99909997 u999_everybody
EOF
}

function write_setupdeb_sh(){
echo -e "${GREEN}写入初始化脚本中...${RESET}"
cat > ${MAINPATH}/${CONTAINER_OS}-${VERNAME}/root/setup.sh <<- EOF
echo -e "${GREEN}正在配置，请稍等${RESET}"
bash groupadd.sh
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
apt update
apt upgrade -y
apt install apt-transport-https -y
cd /usr/bin
mv `ls | grep perl` perl
apt install ca-certificates -y
echo -e "${GREEN}将http换为https${RESET}"
sed -i 's/http/https/g' /etc/apt/sources.list
apt update
apt install dialog whiptail wget curl aria2 -y
sed -i '/setup.sh/d' /etc/profile
echo -e "${GREEN}完成！开始使用你的${CONTAINER_OS}${VERCODE} ${VERNAME}${RESET}"
cd ~
rm setup.sh groupadd.sh
EOF
}

function container_install(){
    pkg up -y
    command -v aria2c > /dev/null
    EXITSTATUS=$?
    if [ ${EXITSTATUS} = 1 ];then
        pkg install -y aria2c
    fi
    mkdir -p ${MAINPATH}/${CONTAINER_OS}-${VERNAME}
    echo -e "${GREEN}稍等，正在检查选择${CONTAINER_OS}的最新rootfs...${RESET}"
    ROOTFSTIME=$(curl https://mirrors.bfsu.edu.cn/lxc-images/images/${CONTAINER_OS}/${VERNAME}/${ARCH}/default/ 2> /dev/null | gawk '{print $3}' | tail -n 3 | head -n 1 | gawk -F '"' '{print $2}' | gawk -F '/' '{print $1}')
    echo -e "最新版(时间):${GREEN}${ROOTFSTIME}${RESET}"
    echo -e "请${GREEN}耐心${RESET}等待,而${RED}不要ctrl-c或其他方式终止${RESET}"
    if [ -f ${CONTAINER_OS}-${VERNAME}*.tar.xz ];then
        echo -e "${BLUE}发现存在的rootfs.为防止错误,删除中...${RESET}"
        rm ${CONTAINER_OS}-${VERNAME}*.tar.xz
    fi
    wget https://mirrors.bfsu.edu.cn/lxc-images/images/${CONTAINER_OS}/${VERNAME}/${ARCH}/default/${ROOTFSTIME}/rootfs.tar.xz -O ${CONTAINER_OS}-${VERNAME}.tar.xz
    tar -xvf ${CONTAINER_OS}-${VERNAME}.tar.xz -C ${MAINPATH}/${CONTAINER_OS}-${VERNAME}
    container_script_write
    echo -e "${GREEN}写入dns中${RESET}"
    mkdir -p ${CONTAINER_OS}-${VERNAME}/run/systemd/resolve/
    #淦哦deb系的rootfs解压后会出现err导致resolv.conf硬链接失效,只能手动创建文件夹然后重新写入
    echo "nameserver 8.8.8.8" > ${CONTAINER_OS}-${VERNAME}/etc/resolv.conf
    echo "nameserver 8.8.8.8" > ${CONTAINER_OS}-${VERNAME}/run/systemd/resolve/stub-resolv.conf
    echo -e "${GREEN}删除rootfs中${RESET}"
    rm ${CONTAINER_OS}-${VERNAME}.tar.xz > /dev/null 2>&1
    echo -e "${GREEN}写入配置脚本中${RESET}"
    echo "bash setup.sh" >> ${MAINPATH}/${CONTAINER_OS}-${VERNAME}/etc/profile
    write_groupadd_sh
    if [ "$CONTAINER_OS" == "ubuntu" ] || [ "CONTAINER_OS" == "debian" ];then
        write_setupdeb_sh
    fi
    sleep 0.3
    echo -e "${BLUE}${CONTAINER_OS}${VERCODE} ${VERNAME}${GREEN}安装成功${RESET}!输入${BLUE}start${VERNAME}${RESET}启动并配置容器"
}
