RED="\E[1;31m"
GREEN="\E[1;32m"
YELLOW="\E[1;33m"
BLUE="\E[1;34m"
PINK="\E[1;35m"
CYAN="\e[36m"
RESET="\E[0m"
RNTOOL="${RED}n${YELLOW}t${BLUE}o${PINK}o${CYAN}l${RESET}"
#############预准备
ARCH="$(uname -m)"
TIME=$(date '+%Y-%m-%d %H:%M:%S')
if [ "$ARCH" == "aarch64" ];then
    ARCH="arm64"
fi
OS="$(uname -o)"     #系统
STORAGEPATH="/storage/emulated/0/Download/backup"       #备份及rootfs下载目录
NTOOLLIB="${PREFIX}/lib/ntool"
MAINPATH="${HOME}/.ntool"      #主目录
RAWURL="https://raw.githubusercontent.com/nya-main/ntool/main"       #GitHub raw地址(我是一只懒懒的猫猫)
GHPAGE="https://github.com/nya-main/ntool"

#if [ "${ARCH}" != "arm64" ];then
#    dialog --title "ntool-tui:WARNING" --msgbox "你的架构是${ARCH}而不是arm64/aarch64\n通常来说这会造成问题,但是我已竭力适配不同的架构了\n你可以测试一下" 15 70
#elif [ "${OS}" != "Android" ];then
#    dialog --title "ntool-tui:WARNING" --msgbox "我还没适配除了Android以外的系统呢..." 15 70
#    exit 1
#fi
#termux-wake-lock
mkdir -p ${MAINPATH}/rootfs
#常用功能function
wait_for_dev_tui(){
    dialog --title "ntool-tui:developing tui" --msgbox "正在开发" 15 70
    return 1
}
bad_empty_input(){
    dialog --title "ntool-tui:WARNING" --msgbox "严重错误:不允许的空选项" 15 70
    return 1
}
download_check(){
    EXITSTATUS=$?
    if [ ${EXITSTATUS} != 0 ];then
        echo "${RED}下载出错!停止运行.${RESET}"[]
        exit 1
    fi
}
source ${NTOOLLIB}/basic/start.sh
