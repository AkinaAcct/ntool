mode_change(){
    CURRENTMODE="$(cat ${MAINPATH}/.mode)"
    case ${CURRENTMODE} in
        NORMAL_MULTI-FILE_MODE)
            cp -f ${NTOOLLIB}/ntsource ntsource.mode0
            cat ${NTOOLLIB}/basic/* >> ${NTOOLLIB}/ntsource
            cat ${NTOOLLIB}/container/* >> ${NTOOLLIB}/ntsource
            echo "SINGLE_FILE_MODE" > ${MAINPATH}/.mode
            ;;
        SINGLE_FILE_MODE)
            rm ${NTOOLLIB}/ntsource
            mv ntsource.mode0 ntsource
            echo "NORMAL_MULTI-FILE_MODE" > ${MAINPATH}/.mode
            ;;
    esac
    EXITSTATUS=$?
    if [ ${EXITSTATUS} != 0 ];then
        echo -e "${RED}出错了qwq!请重新安装ntool ;(${RESET}"
    fi
    echo -e "${GREEN}切换完成!${RESET}现在模式:$(cat ${MAINPATH}/.mode)${RESET}"
    return 0
}
