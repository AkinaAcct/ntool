#!/usr/bin/env bash
check_and_update() {
    dialog --title "ntool:branch version" --msgbox "你安装的是v0.6.2分支版本而不是main分支版本.\n升级功能在所有非main分支中都被禁用." 15 70
    exit 1
}
