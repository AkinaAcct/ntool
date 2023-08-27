function ssh_check_install() {
	if command -v ssh; then
		dialog --title "ntool-tui:ssh check" --msgbox "ssh功能较少,BUG多多,慎用" 15 70
		ssh_tui
	else
		echo "${RED}未安装ssh客户/服务端${RESET}"
		echo "${GREEN}安装中...${RESET}"
		pkg install -y openssh
		echo -e "${GREEN}"
		echo "完成"
		read -p "按任意键以继续"
		echo -e "${RESET}"
		ssh_check_install
	fi
}

function ssh_tui() {
	SSH_CHOICE=$(dialog --output-fd 1 --title "ntool-tui:ssh tui" --menu "选择一个以继续" 15 70 8 \
		"1" "打开sshd服务(让他人连接)" \
		"2" "通过密码连接远程服务器" \
		"3" "生成密钥" \
		"0" "返回上一页")
	EXITSTATUS=$?
	if [ $EXITSTATUS != 0 ]; then
		tool_tui
	fi
	case $SSH_CHOICE in
	0)
		tool_tui
		;;
	1)
		sshd
		echo -e "${GREEN}"
		read -p "启动完成 按任意键继续"
		echo -e "${RESET}"
		exit 0
		;;
	2)
		if command -v sshpass; then
			read -p "输入远程服务器ip/域名:" ssh_ip
			read -p "输入要登陆的用户名:" ssh_user
			read -p "输入ssh端口:" ssh_port
			read -p "输入密码:" ssh_passwd
			echo "please wait..."
			sshpass -p ${ssh_passwd} ssh ${ssh_user}@${ssh_ip} -p ${ssh_port}
		else
			echo "sshpass未安装"
			echo "installing..."
			pkg install -y sshpass
			ssh_tui
		fi
		;;
	3)
		while true; do
			EMAILINPUT=$(dialog --output-fd 1 --title "ntool-tui:keygen" --inputbox "使用RSA\n输入你的邮箱:" 15 70)
			EXITSTATUS=$?
			if [ -a EMAILINPUT ]; then
				bad_empty_input
			elif [ $EXITSTATUS != 0 ]; then
				ssh_tui
				break
			else
				break
			fi
		done
		echo -e "${GREEN}接下来请一路回车${RESET}"
		ssh-keygen -t rsa -C "$EmailInput"
		echo -e "${GREEN}完成!\n公钥在:${HOME}/.ssh/id_rsa.pub\n私钥在:${HOME}/.ssh/id_rsa"
		read -p "按任意键继续"
		;;
	esac
}
