CURRENTMODE="$(cat ${MAINPATH}/.mode)"
mode_change(){
    ACTIONNUM=$(dialog --output-fd 1  --title "ntool:mode changer" --menu "当前你的模式为:${CURRENTMODE}" 15 70 8 \
    "0" "退出" \
    "1" "切换至默认模式(多文件模式)" \
    "2" "单文件模式(启动速度非常慢)")
    case ${ACTIONNUM} in
        0)
            exit 0
            ;;
        1)
            rm -rf ${NTOOLLIB}
            git clone ${GHREPO} ${NTOOLLIB}
            echo "NORMAL_MULIT-FILE_MODE" > ${MAINPATH}/.mode
            ;;
        2)
            wait_for_dev_tui
            cat ${NTOOLLIB}/basic/* >> ${NTOOLLIB}/ntsource
            cat ${NTOOLLIB}/container/* >> ${NTOOLLIB}/ntsource
            sed -i '/source/d' ${NTOOLLIB}/ntsource
            echo "SINGLE_FILE_MODE" > ${MAINPATH}/.mode
            ;;
    esac
    dialog --title "ntool:mode change" --msgbox "更换完成!当前模式为:${CURRENTMODE}" 15 70
    exit 0
}
