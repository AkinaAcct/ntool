#!/bin/bash
#April fool's day
#XD
RED="\E[1;31m"
GREEN="\E[1;32m"
YELLOW="\E[1;33m"
BLUE="\E[1;34m"
PINK="\E[1;35m"
CYAN="\e[36m"
RESET="\E[0m"

function cli_help() {
    echo -e "${GREEN}help \t show this help.\n
    crack path/to/file \t crack an file.\n
    quit/exit \t exit ntool shell.${RESET}"
}
function cli_crack() {
    echo -e "${BLUE}I:checking...${RESET}"
    if [ -z "${1}" ]; then
        echo -e "${RED}E:You need to input an path.${CYAN}see command \"help.\"${RESET}"
    fi
    if [ -f "${1}" ]; then
        echo -e "${RED}E:No such file.Check the path of the file.${RESET}"
    else
        echo -e "${BLUE}T:Please wait.We need 10s to finish the hacking."
        read -p "T:Press ENTER to continue."
        echo -e "${BLUE}cracking...${RESET}"
        hexdump /dev/urandom &
        {
            sleep 10
            kill $! &
        } && echo -e "${BLUE}I:Success.${RESET}"
    fi
}
function cli_shell() {
    echo -e "${GREEN}welcome to ntool shell!${RESET}"
    trap "" SIGINT
    while true; do
        read -r -p "nya@cli $ " COMMAND
        # while true;do
        #     read -N 1 key
        #     if [[ "${key}" == "$(printf "\004")" ]];then
        #         echo "CTRL-D"
        #     fi
        # done
        #
        # check for CTRL-D
        CRACKPATH="$(echo "${COMMAND}" | awk '{print $2}')"
        local COMMAND="$(echo "${COMMAND}" | awk '{print $1}')"
        case "${COMMAND}" in
        exit | quit)
            echo -e "${BLUE}I:Process exited.${RESET}"
            exit 0
            ;;
        help)
            cli_help
            ;;
        crack)
            cli_crack ${CRACKPATH}
            ;;
        *)
            ${COMMAND}
            ;;
        esac
    done
}
