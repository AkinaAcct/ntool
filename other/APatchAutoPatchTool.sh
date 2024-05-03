#!/usr/bin/env bash
# By AtopesSayuri

install() {
    if (! command -v git >/dev/null 2>&1); then
        pkg install -y git
    fi
    git clone https://github.com/AtopesSayuri/APatchAutoPatchTool.git $HOME/AAP || RET=$?
    if [[ $RET -nq 0 ]];then
    echo -e "${RED}E: gir clone failed.${RESET}"
    exit $RET
    fi
    echo -e "${GREEN}I: Success. Path: $HOME/AAP${RESET}"
}
