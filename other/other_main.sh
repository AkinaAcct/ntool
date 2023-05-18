other_main_tui(){
    MAINCHOICE=$(dialog --output-fd 1 --title "ntool" --menu "下面是大佬们的作品!" "1" "termux-container_moe-hacker" "2" "xbtooln_myxuebi" "0" "返回脚本主页" 15 70 8
    echo -e "${BLUE}安装中...${RESET}"
    case ${MAINCHOICE} in
        1)
            source ${NTOOLLIB}/other/termux-container.sh
            install_termux-container
            exit 0
            ;;
        2)
            bash -c "$(curl https://raw.githubusercontent.com/myxuebi/xbtooln/master/xbtooln.sh)"
            exit 0
            ;;
        0)
            termux_main_tui
            ;;
    esac
}
