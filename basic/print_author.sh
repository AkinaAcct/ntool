function print_author(){
    figlet "${1}
written by
${2}" | lolcat -a -d 3
}
