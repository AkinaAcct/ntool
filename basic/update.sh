#!/usr/bin/env bash
check_and_update() {
	dialog --title "ntool:update" --msgbox "你安装的是分支v0.7.0版本，不允许通过cli更新."
	exit 1
}
