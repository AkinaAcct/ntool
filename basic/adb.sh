#!/usr/bin/env bash

function adb_pair() {
	echo -e "${BLUE}注意！此版ntool所使用的配对方法为通知栏输入配对。${RESET}"
	echo -e "${RED}请提前打开无线adb，并选择使用配对码配对。在接下来的20秒内，你将有十秒时间来进行输入。前十秒为配对码，后十秒为配对端口。填写时请拉下通知栏，在出现的termux消息中填写。注意不要填错或填反端口与配对码。${RESET}"
	read -p "按回车以继续。"
	echo -e "${BLUE}开始配对，正在生成通知...${RESET}"
	termux-notification --button1 "输入配对码" --button1-action "echo \"\$REPLY\" > PAIRCODE"
	echo "十秒后进行端口获取"
	sleep 10
	termux-notification --button1 "输入配对端口" --button1-action "echo \"\$REPLY\" > PAIRPORT"
	echo "十秒后开始配对"
	sleep 10
	cat PAIRPORT
	cat PAIRCODE

	adb pair 127.0.0.1:$(cat PAIRPORT) $(cat PAIRCODE) && touch ${MAINPATH}/.pair_success || echo "${RED}配对错误!${RESET}" exit 114

}

function adb_main() {
	if [ ! -f "${MAINPATH}/.pair_success" ]; then
		adb_pair
	fi
	read -p "输入adb连接端口: " ADBPORT
	adb connect 127.0.0.1:${ADBPORT}
	CHOICE=$(dialog --output-fd 1 --title "ntool:adb_main" --menu "本页面所有功能仅供支持无线adb的设备使用!\n选择一个以继续" 15 70 8 \
		"1" "修复类原生ROM网络连接受限" \
		"2" "修改安卓进程限制(保后台)" \
		"3" "高级重启" \
		"0" "返回上级菜单")
	case ${CHOICE} in
	1)
		echo -e "${BLUE}使用MIUI genarate 204"
		adb shell settings put global captive_portal_https_url https://connect.rom.miui.com/generate_204
		adb shell settings put global captive_portal_http_url http://connect.rom.miui.com/generate_204
		echo -e "${GREEN}完成!请开关飞行模式或重启手机使其生效${RESET}"
		;;
	2)
		MAXPROCNMUM=$(dialog --output-fd 1 --title "ntool:adb" --inputbox "输入要修改的最大进程数\n最大为21474836473" 15 70)
		if [ -z "${MAXPROCNMUM}" ]; then
			bad_empty_input
			adb_main
			exit 0
		fi
		adb shell device_config set_sync_disabled_for_tests persistent
		adb shell device_config put activity_manager max_phantom_processes "${MAXPROCNMUM}"
		;;
	3)
		echo -e "${BLUE}1. system\n2. recovery\n3. fastboot\n4. edl"
		read -r -p "选择一个以继续: " REBOOTMODE
		echo -e "${RESET}"
		case ${REBOOTMODE} in
		1)
			MODE=""
			;;
		2)
			MODE=recovery
			;;
		3)
			MODE=fastboot
			;;
		4)
			MODE=edl
			;;
		*)
			echo -e "${RED}出错了!输入正确的数字啊qwq${RESET}"
			adb_main
			;;
		esac
		echo -e "${RED}"
		read -r -p "你确定要继续吗?你将进入${MODE}模式!你未保存的工作数据将丢失! [Y|N]" CHOICE
		echo -e "${RESET}"
		if [[ "$CHOICE" == "Y" || "$CHOICE" == "y" ]]; then
			adb reboot "${MODE}"
		else
			adb_main
		fi
		;;
	*)
		other_main_tui
		;;
	esac
}
