check_and_update(){
    if [ "$(curl ${RAWURL}/version)" != "$(cat ${MAINPATH}/local_version)" ];then
        if (dialog --title "ntool-tui:install&update" --yesno "你的版本不是最新版。是否更新？\n最新版:$(curl ${RAWURL}/version 2> /dev/null)\n本地版本:$(cat ${MAINPATH}/local_version)" 15 70);then
            echo -e "${BLUE}更新中...${RESET}"
            pkg up -y
            pkg install -y git wget curl python x11-repo dialog jq
            rm -rf ${NTOOLLIB}
            git clone https://github.com/nya-main/ntool ${NTOOLLIB}
            curl ${RAWURL}/version ${MAINPATH}/local_version
            echo -e "${GREEN}完成!输入ntool以启动!${RESET}"
            exit 0
        else
            termux_main_tui
        fi
    else
        dialog --title "ntool-tui:check update" --msgbox "你的版本为最新版，无需更新" 15 70
        exit 0
    fi
}
