#!/usr/bin/env bash


function backup_tui() { #备份页面function
    backup_tui_choice=$(dialog --output-fd 1 --title "ntool-tui:backup tui" --menu "选择一个以继续" 15 70 8 \
        "0" "返回脚本主页" \
        "1" "备份termux" \
        "2" "恢复备份" \
        "3" "删除备份")
    EXITSTATUS=$?
    if [ $EXITSTATUS != 0 ]; then
        termux_main_tui
    fi
    case $backup_tui_choice in
    0)
        termux_main_tui
        ;;
    1)
        BACKUP_NAME=$(dialog --output-fd 1 --title "ntool-tui:backup name" --inputbox "输入备份名(仅备份com.termux/files以提高速度) " 15 70)
        EXITSTATUS=$?
        if [ $EXITSTATUS != 0 ]; then
            backup_tui
        elif [ -z $BACKUP_NAME ]; then
            bad_empty_input
            backup_tui
        fi
        cd ~
        if command -v tar >/dev/null; then
            if [ -d storage ]; then
                dialog --title "ntool-tui:tips" --msgbox "备份可能会很慢,请耐心等待" 15 70
                cd /data/data/com.termux/
                tar -cvpzf ${STORAGEPATH}/${BACKUP_NAME}.tgz files
                echo -e "${GREEN}计算sha1...${RESET}"
                sha1sum ${STORAGEPATH}/${BACKUP_NAME}.tgz >${STORAGEPATH}/${BACKUP_NAME}.tgz.sha
                echo -e "${GREEN}完成备份${RESET}"
                read -p "按任意键退出"
                backup_tui
            else
                echo -e "${RED}termux-setup-storage未执行${RESET}"
                echo -e "${BLUE}执行中...${RESET}"
                sleep 2
                termux-setup-storage
                echo "${GREEN}完成${RESET}"
                backup_tui
            fi
        else
            echo "tar未安装"
            echo "start installing..."
            pkg install -y tar
            backup_tui
        fi
        ;;
    2)
        RESTORE_PATH=$(dialog --output-fd 1 --title "ntool-tui:输入完整目录！" --inputbox ${STORAGEPATH} 15 70)
        EXITSTATUS=$?
        if [ $EXITSTATUS != 0 ]; then
            backup_tui
            exit 0
        elif [ -z $RESTORE_PATH ]; then
            bad_empty_input
            backup_tui
        fi
        cd ~
        echo "比对sha中..."
        sha1sum -c ${RESTORE_PATH}.sha >>/dev/null 2>&1
        EXITSTATUS=$?
        if [ $EXITSTATUS = 0 ]; then
            echo -e "${GREEN}sha正常${RESET}"
            echo "${GREEN}3${BLUE}秒后开始恢复${RESET}"
            sleep 3
            tar -xvpzf ${RESTORE_PATH} -C /data/data/com.termux/
            echo -e "${GREEN}完成，重启生效，按回车以退出${RESET}"
        else
            dialog --title "ntool-tui:WARNING" --msgbox "警告:不匹配的sha值!不进行恢复" 15 70
            backup_tui
        fi
        ;;
    3)
        DEL_BACKUP_PATH=$(dialog --output-fd 1 --title "ntool-tui:输入完整目录" --inputbox "输入完整tgz文件路径" 15 70)
        EXITSTATUS=$?
        if [ $EXITSTATUS != 0 ]; then
            backup_tui
        elif [ -z $DEL_BACKUP_PATH ]; then
            bad_empty_input
            backup_tui
        fi
        rm -v ${DEL_BACKUP_PATH}
        rm -v ${DEL_BACKUP_PATH}.sha
        read -p "按任意键继续"
        backup_tui
        ;;
    esac
}
