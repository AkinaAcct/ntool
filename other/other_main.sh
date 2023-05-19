other_main_tui(){
    MAINCHOICE=$(dialog --output-fd 1 --title "ntool" --menu "下面是一些其他大佬的项目和一些好van的\n:)" 15 70 8 \
    "1" "termux-container_moe-hacker" \
    "2" "xbtooln_myxuebi" \
    "3" "NeoVim-Config_nya" \
    "0" "返回脚本主页")
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
        3)
            echo -e "${YELLOW}注意!vim配置将不再更新!仅更新neovim配置!"
            read -p "按回车以继续"
            echo -e "${RESET}"
            git clone https://github.com/nya-main/VimConfigBackup ~/vcb-nya
            mkdir -p ~/.config
            cp -rf ~/vcb-nya/nvim ~/.config
            ;;
        0)
            termux_main_tui
            ;;
    esac
    echo -e "${RED}完成!${RESET}"
}
