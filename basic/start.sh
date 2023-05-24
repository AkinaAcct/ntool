source "${NTOOLLIB}/ntmain"
start(){
    if [ $# -gt 1 ];then
        echo -e "${RED}more than one parameter had been inputted${RESET}"
        exit 1
    elif [ $# -lt 1 ];then
        termux_main_tui
    fi
    case ${*} in
        -d|--debug)
            echo ${TIME} > ~/log.txt
            exec 2>> ~/log.txt
            set -x
            dialog --title "ntool-tui:WARNING" --msgbox "debug/set -x模式已启动 \n所有执行的命令都会被打印出来再执行\n 有一份命令复制保存在~/log.txt" 15 70
            termux_main_tui
            ;;
        -s|--strict)
            set -e
            dialog --title "ntool-tui:WARNING" --msgbox "严格模式/set -e已经启动 \n出现任何报错将直接终止脚本运行 \n该模式下容器安装一定会报错" 15 70
            termux_main_tui
            ;;
        -v|--version)
             NTOOLVERSION="$(cat ${MAINPATH}/local_version 2> /dev/null)"
            if [ -z ${NTOOLVERSION} ];then
                echo -e "${RNTOOL}\n version:${RED}ERR-FILE-NOT-FOUND${RESET}\n mode:${GREEN}normal mode${RESET}"
            else
                echo -e "${RNTOOL}\n version:${BLUE}${NTOOLVERSION}${RESET}\n mode:${GREEN}$(cat ${MAINPATH}/.mode)${RESET}"
            fi
            exit 0
            ;;
        -h|--help)
            source "${NTOOLLIB}/basic/print_help.sh"
            print_help
            ;;
        -u|--update)
            source "${NTOOLLIB}/basic/update.sh"
            check_and_update
            ;;
        -g|--github)
            am start -a android.intent.action.VIEW -d ${GHREPO} > /dev/null 2>&1
            exit 0
            ;;
        --uninstall)
            source "${NTOOLLIB}/basic/uninstall.sh"
            uninstall_ntool
            exit 0
            ;;
    esac
    echo -e "${RED}Unknown parameter:${*}${RESET}"
}

