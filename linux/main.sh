#!/bin/bash

CHOICE=$(dialog --output-fd 1 --title "ntool" --menu "Welcome!Chose one to continue." 15 70 8 \
    "1" "换源" \
    "2" "没想好" \
    "0" "退出")
case ${CHOICE} in
1)
    echo -e "${GREEN}T代表清华源,B代表北外源,U代表中科大源${RESET}"
    read -p -r "选择你的捍卫者(划掉)  选择你要更改的镜像站: " answer
    case ${answer} in
    T | t) STATION="mirrors.tuna.tsinghua.edu.cn" ;;
    B | b) STATION="mirrors.bfsu.edu.cn" ;;
    U | u) STATION="mirrors.ustc.edu.cn" ;;
    *)
        STATION=""
        echo -e "${RED}未知的选项:${RESET} ${answer}"
        echo -e "别乱选啊喂!"
        sleep 3
        ;;
    esac
    if [[ -n ${STATION} ]]; then
        echo -e "${RED}developing...${RESET}"
        exit 1
    fi
    ;;
2)
    dialog --title "啊这..." --msgbox "${BLUE}我说没想好辣...${RESET}" 15 70
    source "${HOME}/.local/ntool/linux/main.sh"
    ;;
0) exit 0 ;;
esac
