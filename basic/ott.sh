function other_tool_tui() { #这里是其他功能页的function
    OTPC=$(dialog --output-fd 1 --title "ntool-tui:other tool tui" --menu "选择一个以继续" 15 70 8 \
        "1" "工具页面" \
        "0" "返回上一页")
    EXITSTATUS=$?
    if [ $EXITSTATUS != 0 ]; then
        termux_main_tui
    fi
    case $OTPC in
    0)
        termux_main_tui
        ;;
    1)
        source "${NTOOLLIB}/basic/tool.sh"
        tool_tui
        ;;
    esac
}
