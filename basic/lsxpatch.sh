#!/usr/bin/env bash


function patch_framework_choose() {
    if (dialog --title "ntool-tui:WARNING" --yesno "你在使用一个测试功能\n 你确定要继续吗" 15 70); then
        EXITSTATUS=$?
        if [ $EXITSTATUS != 0 ]; then
            termux_main_tui
        fi
        dialog --title "ntool-tui:选择patch框架" --yes-label "XPatch" --no-label "LSPatch" --yesno "基于Java，选择任何一个选项都将安装OpenJdk17\n本页面用于免root使用lsp或xp注入应用\nLSPatch的应用仅支持安卓9及以上但较为稳定\nXPatch则是几乎全版本支持但稳定性不好,支持的模块也大大少于LSPatch\n两种patch方式都很像无极" 15 70
        EXITSTATUS=$?
        case ${EXITSTATUS} in
        0)
            PATCHFRAMEWORK=xpatch
            ;;
        1)
            PATCHFRAMEWORK=lspatch
            ;;
        esac
        if command -v java jq >/dev/null 2>&1; then
            patch_apk
        else
            pkg install -y openjdk-17 jq
            patch_apk
        fi
    else
        termux_main_tui
    fi
}

function patch_apk() {
    APKPATH=$(dialog --output-fd 1 --title "ntool-tui:fast ${PATCHFRAMEWORK}" --inputbox "输入apk完整路径\n 不是apk文件的上一级目录!!!" 15 70)
    EXITSTATUS=$?
    if [ $EXITSTATUS != 0 ]; then
        patch_framework_choose
    elif [ -z $APKPATH ]; then
        bad_empty_input
        patch_apk
    fi
    mkdir -p ${MAINPATH}/patch
    case ${PATCHFRAMEWORK} in
    xpatch)
        echo -e "${BLUE}获取最新版本号中${RESET}"
        TAG=$(wget -qO- -t1 -T2 "https://api.github.com/repos/WindySha/Xpatch/releases/latest" | jq -r '.tag_name')
        echo -e "${GREEN}${PATCHFRAME}最新版为${TAG}${RESET}"
        wget https://github.com/WindySha/Xpatch/releases/download/${TAG}/xpatch-${tag}.jar -O ${MAINPATH}/patch/xpatch.jar
        ;;
    lspatch)
        TAG=$(wget -qO- -t1 -T2 "https://api.github.com/repos/LSPosed/LSPatch/releases/latest" | jq -r '.tag_name')
        echo -e "${GREEN}${PATCHFRAME}最新版为${TAG}${RESET}"
        wget https://github.com/LSPosed/LSPatch/releases/download/${TAG}/lspatch.jar -O ${MAINPATH}/patch/lspatch.jar
        ;;
    esac
    if [ ! -f ${APKPATH} ]; then
        dialog --title "ntool-tui:failed" --msgbox "无效的apk文件路径\n 检查是否输入错误或有无给予内置存储权限" 15 70
        patch_apk
    fi
    MODULEPATH=$(dialog --output-fd 1 --title "ntool-tui:选择模块" --inputbox "输入模块apk的完整路径\n 不是apk文件的上一级目录!!!" 15 70)
    echo -e "${BLUE}可能${RED}较慢${RESET},请${GREEN}耐心等待${RESET}"
    if [ "${PATCHFRAMEWORK}" == "xpatch" ]; then
        java -jar ${MAINPATH}/patchedapks/xpatch.jar ${APKPATH} -xm ${MODULEPATH} -o /sdcard/xpatchedapk.apk
        rm ${MAINPATH}/patchedapks/xpatch.jar
    else
        java -jar ${MAINPATH}/patchedapks/lspatch.jar ${APKPATH} -m ${MODULEPATH} -o /sdcard
        rm ${MAINPATH}/patchedapks/lspatch.jar
    fi
    echo -e "${GREEN}完成!修改后的apk${BLUE}在这里↑↑↑↑↑上面${RESET}"
    read -p "按回车继续"
    exit 0
}
