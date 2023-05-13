mode_change(){
    case $(cat ${MAINPATH}/.mode) in
        0)
            cp -f ${NTOOLLIB}/ntsource ntsource.mode0
            cat ${NTOOLLIB}/basic/* >> ${NTOOLLIB}/ntsource
            cat ${NTOOLLIB}/container/* >> ${NTOOLLIB}/ntsource
            echo -e "SINGLE_FILE_MODE" > ${MAINPATH}/.mode
            ;;
        1)
            rm ${NTOOLLIB}/ntsource
            mv ntsource.mode0 ntsource
            echo "NORMAL_MULTI-FILE_MODE" > ${MAINPATH}/.mode
            ;;
    esac
    echo -e "${GREEN}切换完成!${RESET}现在模式:$(cat ${MAINPATH}/.mode)${RESET}"
    return 0
}
