#!/usr/bin/env bash

function uninstall_ntool() {
    echo -e "${RED}你的ntool数据将丢失!容器等将被完全删除!"
    read -r -p "你确定要卸载ntool吗?  [Y|N]" CHOICE
    echo -e "${RESET}"
    case ${CHOICE} in
    Y | y)
        rm -rf "${NTOOLLIB}"
        rm -rf "${MAINPATH}"
        rm -rf "${PREFIX}"/bin/ntool
        echo -e "${GREEN}完成.ntool已经被卸载了.${RESET}"
        exit 0
        ;;
    N | n)
        termux_main_tui
        ;;
    *)
        echo -e "${RED}未知的选择: \"${CHOICE}\" .exited.${RESET}"
        exit 1
        ;;
    esac
    exit 0
}
