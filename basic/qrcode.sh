function qrcode_tui(){
    QRCHOICE=$(dialog --output-fd 1 --title "ntool-tui:按<ESC>返回上一页" --yes-label "生成" --no-label "解码" --yesno "使用 \nqrencode 和 zbar实现 \n选择一个以继续" 15 70)
    EXITSTATUS=$?
    if [ ${EXITSTATUS} = 255 ];then
        tool_tui
    fi
    case ${EXITSTATUS} in
        0)
            QRSPAWN=$(dialog --output-fd 1 --title "ntool-tui:qrcode spawn" --inputbox "输入你想要加密的文本" 15 70)
            EXITSTATUS=$?
            if [ ${EXITSTATUS} != 0 ];then
                qrcode_tui
            fi
            dialog --output-fd 1 --title "ntool-tui:configure" --yesno "是否要保存该二维码到内置存储目录?" 15 70
            EXITSTATUS=$?
            if [ ${EXITSTATUS} != 0 ];then
                qrencode -o - -t ANSI "${QRSPAWN}"
                echo -e "${GREEN}"
                read -p "按回车继续"
                echo -e "${RESET}"
                qrcode_tui
            else
                QRSTOREPATH=$(dialog --output-fd 1 --title "按空格选择" --dselect "/sdcard" 15 70)
                EXITSTATUS=$?
                if [ ${EXITSTATUS} != 0 ];then
                    qrcode_tui
                elif [ -z ${QRSTOREPATH} ];then
                    bad_empty_input
                    qrcode_tui
                fi
                qrencode -t png -o ${QRSTOREPATH}/qrcode-${QRSPAWN}.png "${QRSPAWN}"
                catimg ${QRSTOREPATH}/qrcode-${QRSPAWN}.png
                echo -e "${GREEN}完成!保存在${BLUE}${QRSTOREPATH}/qrcode-${QRSPAWN}.png${RESET}"
                echo -e "${GREEN}"
                read -p "按回车继续"
                echo -e "${RESET}"
                qrcode_tui
            fi
            ;;
        1)
            QRUNCODEPATH=$(dialog --output-fd 1 --title "ntool-tui:qrcode uncode" --fselect "选择好文件后按空格选择(删掉我),或者直接输入完整路径" 15 70)
            EXITSTATUS=$?
            if [ -z ${QRUNCODEPATH} ];then
                bad_empty_input
                qrcode_tui
            elif [ ${EXITSTATUS} != 0 ];then
                qrcode_tui
            fi
            echo -e "${BLUE}结果${RESET}:$(zbarimg ${QRUNCODEPATH} | sed -n '1p')"
            echo -e "${GREEN}"
            read -p "按回车继续"
            echo -e "${RESET}"
            qrcode_tui
            ;;
    esac
}
