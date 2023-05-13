mode_change(){
    case $(cat ${MAINPATH}/.mode) in
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
        *)
            echo -e "${RED}出戳了!请重新安装ntool ;(${RESET}"
            exit 1
            ;;
    esac
    echo -e "${GREEN}切换完成!${RESET}现在模式:$(cat ${MAINPATH}/.mode)${RESET}"
    return 0
}
