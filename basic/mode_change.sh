set -x
CURRENTMODE="$(cat ${MAINPATH}/.mode)"
mode_change(){
    ACTIONNUM=$(dialog --output-fd 1  --title "ntool:mode change" --menu "当前你的模式为:$(cat ${MAINPATH}/.mode)" 15 70 8 \
    "0" "退出" \
    "1" "切换至默认模式(多文件模式)" \
    "2" "切换至无tui模式")
    case ${ACTIONNUM} in
        0)
            exit 0
            ;;
        1)
            rm -rf ${NTOOLLIB}
            git clone ${GHREPO} ${NTOOLLIB}
            dialog --title "ntool:mode change" --msgbox "更换完成!当前模式为:$(cat ${MAINPATH}/.mode)" 15 70
            exit 0
            ;;
        2)
            wait_for_dev_tui
            ;;
    esac
}
