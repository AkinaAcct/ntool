#事实上,这个功能的初衷是我自己要用XD
function adb_pair(){
    echo -e "${RED}警告!本功能仅支持能够使用无线adb的设备!不支持无线adb的设备将无法使用!"
    echo -e "${GREEN}请进入手机的开发者选项打开无线adb功能"
    read -p "选择与\"配对码\"有关的选项并将码填写至此: " PAIRCODE
    read -p "输入同时出现的端口: " PAIRPORT
    echo -e "${RESET}"
    adb pair 127.0.0.1:${PAIRPORT} ${PAIRCODE}
    EXITSTATUS=$?
    if [ ${EXITSTATUS} != 0 ];then
        echo -e "${RED}配对出错了!如果你还是不知道如何配对,请参考${BLUE}shizuku${RED}的配对方法.${RESET}"
        exit 1
    fi
}

function adb_main(){
    adb_pair
    CHOICE=$(dialog --output-fd 1 --title "ntool:adb_main" --menu "本页面所有功能仅供支持无线adb的设备使用!\n选择一个以继续" 15 70 8 \
    "1" "修复类原生ROM网络连接受限" \
    "0" "返回上级菜单")
    case ${CHOICE} in
        1)
            echo -e "${BLUE}使用MIUI genarate 204"
            adb shell settings put global captive_portal_https_url https://connect.rom.miui.com/generate_204
            adb shell settings put global captive_portal_http_url http://connect.rom.miui.com/generate_204
            echo -e "${GREEN}完成!请开关飞行模式或重启手机使其生效${RESET}"
            ;;
        0)
            other_main_tui
            ;;
    esac
}
