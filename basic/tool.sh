function tool_tui() { #这里是其它工具-工具类页面的function
    TPC=$(dialog --output-fd 1 --title "ntool-tui:tool tui" --menu "选择一个以继续" 15 70 8 \
        "1" "ping" \
        "2" "ping6" \
        "3" "文件查找" \
        "4" "安装openjdk17" \
        "5" "ssh功能" \
        "6" "二维码功能" \
        "7" "rm防误删" \
        "00" "打开该项目地址(?)" \
        "0" "返回上一页")
    EXITSTATUS=$?
    if [ $EXITSTATUS != 0 ]; then
        other_tool_tui
    fi
    case $TPC in
    0)
        other_tool_tui
        ;;
    00)
        print_author NTool nya
        am start -a android.intent.action.VIEW -d ${GHREPO} >/dev/null 2>&1
        ;;

    1)
        if command -v ping >/dev/null 2>&1; then
            ip=$(dialog --output-fd 1 --title "ntool-tui:ping-ip" --inputbox "输入要进行ping的IP/域名(必填)"15 70)
            time=$(dialog --output-fd 1 --title "ntool-tui:ping-time" --inputbox "输入要ping的次数(选填)" 15 70)
            speed=$(dialog --output-fd 1 --title "ntool-tui:ping-speed" --inputbox "输入ping的速度(选填)（以秒为单位，省略符号，无root最快0.2）" 15 70)
            size=$(dialog --output-fd 1 --title "ntool-tui:ping-packet-szie" --inputbox "输入ping包大小(选填)(以字节为单位，最大65507)" 15 70)
            if [ -z $ip ] || [ -z $time ] || [ -z $speed ] || [ -z $size ]; then
                bad_empty_input
                tool_tui
            else
                echo -e "${BLUE}start ping${RESET}"
                ping -i ${speed} -c${times} -s ${size} ${ip}
                echo -e "${GREEN}stop ping${RESET}"
            fi
        else
            echo "未安装ping，正在安装..."
            pkg install -y termux-tools
            tool_tui
        fi
        ;;
    2)
        if command -v ping6 >/dev/null; then
            ip=$(dialog --output-fd 1 --title "ntool-tui:ping6-ip" --inputbox "输入要进行ping6的IP/域名(必填)"15 70)
            time=$(dialog --output-fd 1 --title "ntool-tui:ping6-time" --inputbox "输入要ping6的次数(选填)" 15 70)
            speed=$(dialog --output-fd 1 --title "ntool-tui:ping6-speed" --inputbox "输入ping6的速度(选填)（以秒为单位，省略符号，无root最快0.2）" 15 70)
            size=$(dialog --output-fd 1 --title "ntool-tui:ping6-packet-szie" --inputbox "输入ping6包大小(选填)(以字节为单位，最大65507)" 15 70)
            if [ -z $ip ] || [ -z $time ] || [ -z $speed ] || [ -z $size ]; then
                bad_empty_input
                tool_tui
            else
                echo -e "${BLUE}start ping${RESET}"
                ping6 -i ${speed} -c${time} -s ${size} ${ip}
                echo -e "${GREEN}stop ping${RESET}"
            fi
        else
            echo "ping6未安装,正在安装..."
            pkg install -y termux-tools
            tool_tui
        fi
        ;;
    3)
        filename=$(dialog --output-fd 1 --title "ntool-tui:find file" --inputbox "输入你要搜索的文件:" 15 70)
        filepath=$(dialog --output-fd 1 --title "ntool-tui:find file" --inputbox "输入你要搜索的目录:" 15 70)
        if [ -z $filename ] || [ -z $filepath ]; then
            bad_empty_input
        fi
        echo -e "${BLUE}搜索中${RESET}"
        echo -e "可能${RED}较慢${RESET},请${GREEN}耐心等待${RESET}"
        echo -e "${BLUE}搜索中${RESET}"
        result=$(find -name ${filename} ${filepath})
        echo "${result}" >~/filesearchresult
        echo -e "${GREEN}完成${RESET}"
        echo -e "${BLUE}结果:${RESET}\n${result}"
        echo -e "${GREEN}复制一份于~/filesearchresult"
        read -p "按回车继续"
        echo -e "$RESET"
        tool_tui
        ;;
    4)
        echo "只支持openjdk17"
        read -p "按任意键以继续" #我好水啊（）
        pkg install -y openjdk-17
        echo "安装完成"
        ;;
    5)
        source "${NTOOLLIB}/basic/ssh.sh"
        ssh_check_install
        ;;
    6)
        source "${NTOOLLIB}/basic/qrcode.sh"
        command -v qrencode
        EXITSTATUS=$?
        if [ ${EXITSTATUS} != 0 ]; then
            pkg install -y libqrencode zbar
            qrcode_tui
        else
            qrcode_tui
        fi
        ;;
    7)
        source "${NTOOLLIB}/basic/trashbin.sh"
        rm_to_trash
        ;;
    esac
    exit 0
}
