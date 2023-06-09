function rm_to_trash(){
    dialog --title "ntool-tui:按ESC退出" --yes-label "trash-cli" --no-label "rm" --yesno "trash-cli是一个适用于linux命令行下的回收站应用\n相对于rm的直接删除它更为安全,因为可以恢复\n删除后的文件将被保存在回收站\n真的是我的血的教训" 15 70
    EXITSTATUS=$?
    if [ ${EXITSTATUS} = 255 ];then
        tool_tui
    fi
    case ${EXITSTATUS} in
        0)
            if [ $(cat ${PREFIX}/etc/profile | grep trash) ];then
                dialog --title "ntool-tui:tips" --msgbox "你已经安装过啦!下面是一些使用提示: \nrm-文件转移到~/.trash \nrl-显示回收站里的文件 \nrm-restore-选择要从回收站里恢复的文件 \ntrash-empty-清除回收站" 15 70
                exit 0
            else
                if [ ! $(command -v trash) ];then
                    pip install trash-cli
                fi
                cat >> ${PREFIX}/etc/profile << EOF
alias rm='trash-put --trash-dir ~/.trash'
alias rl='trash-list --trash-dir ~/.trash'
alias rm-restore='trash-restore --trash-dir ~/.trash'
alias trash-empty='trash-empty --trash-dir ~/.trash'
EOF
                dialog --title "ntool-tui:tips" --msgbox "完成!重启termux以应用.下面是一些使用提示: \nrm-文件转移到~/.trash \nrl-显示回收站里的文件 \nrm-restore-选择要从回收站里恢复的文件 \ntrash-empty-清除回收站" 15 70
            fi
            ;;
        1)
            sed -i '/trash/d' ${PREFIX}/etc/profile
            dialog --title "ntool-tui:tips" --msgbox "完成!" 15 70
            tool_tui
            ;;
    esac
}
