#!/usr/bin/env bash

function ntool_pandoc() {
    echo "${GREEN}输入源文件路径:"
    read ORIGINPATH
    echo "输入输出文件路径:"
    read OUTPUTPATH
    echo "输入源文件格式:"
    read ORIGINFORMAT
    echo "输入输出文件格式:${RESET}"
    read OUTPUTFORMAT

    echo -e "${BLUE}检测参数是否正确...${RESET}"

    #下面是一连串的判断环境，参数与命令的if语句
    if [[ -z ${ORIGINPATH} || -z ${ORIGINFORMAT} || -z ${OUTPUTPATH} || -z ${OUTPUTFORMAT} ]]; then
        echo -e "${RED}参数有缺失。不予运行。${RESET}"
        sleep 2
        ntool_pandoc
    fi

    if (! command -v pandoc >/dev/null 2>&1); then
        echo -e "${RED}pandoc并未安装。不予运行。${RESET}"
        sleep 2
        ntool_pandoc
    fi

    if [[ -f ${ORIGINPATH} || -w ${OUTPUTPATH} ]]; then
        if [[ ! -f ${ORIGINPATH} ]]; then
            echo -e "${RED}源文件路径存在问题。不予运行。${RESET}"
            sleep 2
            ntool_pandoc
        elif [[ ! -w ${OUTPUTPATH} || -d ${OUTPUTPATH} ]]; then
            echo -e "${RED}输出文件路径存在问题。不予运行。${RESET}"
            sleep 2
            ntool_pandoc
        fi
    fi

    if (! pandoc --list-input-formats | grep "${ORIGINFORMAT}" >/dev/null 2>&1); then
        echo -e "${RED}检测到源文件不支持的格式：\"${ORIGINFORMAT}\"。不予运行。${RESET}"
        echo -e "${BLUE}支持的源文件格式有： \n $(pandoc --list-input-formats)${RESET}"
        sleep 2
        ntool_pandoc
    elif (! pandoc --list-output-formats | grep "${OUTPUTFORMAT}" >/dev/null 2>&1); then
        echo -e "${RED}检测到输出文件不支持的格式：\"${OUTPUTFORMAT}\"。不予执行。${RESET}"
        echo -e "${BLUE}支持的输出文件格式有： \n $(pandoc --list-output-formats)${RESET}"
        sleep 2
        ntool_pandoc
    fi
    pandoc --from="${ORIGINFORMAT}" \
        --to="${OUTPUTFORMAT}" \
        --output="${OUTPUTPATH}" \
        "${ORIGINPATH}" && echo -e "${GREEN}转换完毕。生成的文件在： ${OUTPUTPATH}。${RESET}" && exit 0 || echo -e "${RED}未知原因导致的失败。${RESET}"
}
