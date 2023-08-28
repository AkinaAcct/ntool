#!/usr/bin/env bash


#事实上,写这个功能是因为我自己要用XD

function check_vpn() {
    ifconfig | awk '{print $1}' | grep tun
    EXITSTATUS=$?
    if [ ${EXITSTATUS} = 0 ]; then
        echo -e "${RED}检测到VPN连接.停止运行"
        read -p "按回车继续"
        adb_main
    fi
}

function adb_connect() {
    echo -e "${GREEN}请进入手机的开发者选项打开无线adb功能,并选择使用配对码配对."
    read -r -p "输入出现的端口: " PORT
    adb connect 127.0.0.1:${PORT}
    EXITSTATUS=$?
    if [ ${EXITSTATUS} != 0 ]; then
        echo -e "${RED}出错了!请重新运行!${RESET}"
        exit 1
    fi
    adb devices -l
}

function adb_pair() {
    echo -e "${RED}警告!本功能仅支持能够使用无线adb并能够以配对码配对的的设备(Android 11+)!不支持无线adb的设备将无法使用!"
    echo -e "${GREEN}请进入手机的开发者选项打开无线adb功能,并选择使用配对码配对."
    read -p "输入同时出现的端口: " PAIRPORT
    echo -e "${YELLOW}确保你未使用VPN!${RESET}如果有使用,请${YELLOW}现在关闭.${RESET}"
    read -p "按回车以继续"
    echo -e "${RESET}"
    check_vpn
    echo -e "${RESET}"
    echo -e "在下方输入配对码"
    adb pair 127.0.0.1:${PAIRPORT}
    EXITSTATUS=$?
    if [ ${EXITSTATUS} != 0 ]; then
        echo -e "${RED}配对出错了!如果你还是不知道如何配对,请参考${BLUE}shizuku${RED}的配对方法.${RESET}"
        exit 1
    fi
    touch .pair_success ${MAINPATH}
}

function adb_main() {
    if [ ! -f "${MAINPATH}/.pair_success" ]; then
        adb_pair
    fi
    adb_connect
    CHOICE=$(dialog --output-fd 1 --title "ntool:adb_main" --menu "本页面所有功能仅供支持无线adb的设备使用!\n选择一个以继续" 15 70 8 \
        "1" "修复类原生ROM网络连接受限" \
        "2" "修改安卓进程限制(保后台)" \
        "3" "高级重启" \
        "0" "返回上级菜单")
    case ${CHOICE} in
    1)
        echo -e "${BLUE}使用MIUI genarate 204"
        adb shell settings put global captive_portal_https_url https://connect.rom.miui.com/generate_204
        adb shell settings put global captive_portal_http_url http://connect.rom.miui.com/generate_204
        echo -e "${GREEN}完成!请开关飞行模式或重启手机使其生效${RESET}"
        ;;
    2)
        MAXPROCNMUM=$(dialog --output-fd 1 --title "ntool:adb" --inputbox "输入要修改的最大进程数\n最大为21474836473" 15 70)
        if [ -z ${MAXPROCNMUM} ]; then
            bad_empty_input
            adb_main
            exit 0
        fi
        adb shell device_config set_sync_disabled_for_tests persistent
        adb shell device_config put activity_manager max_phantom_processes ${MAXPROCNMUM}
        ;;
    3)
        echo -e "${BLUE}1. system\n2. recovery\n3. fastboot\n4. edl"
        read -p "选择一个以继续: " REBOOTMODE
        echo -e "${RESET}"
        case ${REBOOTMODE} in
        1)
            MODE=
            ;;
        2)
            MODE=recovery
            ;;
        3)
            MODE=fastboot
            ;;
        4)
            MODE=edl
            ;;
        *)
            echo -e "${RED}出错了!输入正确的数字啊qwq${RESET}"
            adb_main
            ;;
        esac
        echo -e "${RED}"
        read -p "你确定要继续吗?你将进入${MODE}模式!你未保存的工作数据将丢失! [Y|N]" CHOICE
        echo -e "${RESET}"
        if [[ "$CHOICE" == "Y" || "$CHOICE" == "y" ]]; then
            adb reboot ${MODE}
        else
            adb_main
        fi
        ;;
    *)
        other_main_tui
        ;;
    esac
}
