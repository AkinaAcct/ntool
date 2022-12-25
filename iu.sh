#!/data/data/com.termux/files/usr/bin/env bash
#嘿嘿嘿！
#如你所见，这是一个顶级菜鸡的的一个脚本
#属于是离谱了属于是

if [ -d "~/.ntool" ];then
	echo "看起来你似乎已经安装过ntool了"
	echo "你确定要安装/升级吗？"
	read -p "按回车继续"
fi
cd ~
while true
do
read -p "你确定要执行这个脚本吗？  [Y|N]" answer
case $answer in
	Y|y)
		rm ~/.ntool/local_version > /dev/null 2>&1
		echo "installing..."
		apt update
		apt upgrade
		apt install git wget curl neofetch -y
		wget https://raw.githubusercontent.com/nnyyaa/ntool/main/ntool
		mkdir -p .ntool
		rm /data/data/com.termux/files/usr/bin/ntool
		mv ntool /data/data/com.termux/files/usr/bin
		chmod 777 /data/data/com.termux/files/usr/bin/ntool
		cd ~/.ntool
		wget https://raw.githubusercontent.com/nnyyaa/ntool/main/version -O local_version > /dev/null 2>&1
		rm de-i.sh ub-i.sh > /dev/null 2>&1
		cd ~
		rm iu.sh > /dev/null 2>&1
                echo "完成"
                echo "输入ntool测试启动"
		break
		;;
	N|n)
		echo "exiting..."
		break
		;;
	*)
		echo "未知的输入: $answer 请确认输入无误"
		;;
esac
done
exit 0

