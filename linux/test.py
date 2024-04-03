import os
import shutil
import urllib.request as urlreq

os.system("clear")

def apatch_patch(*,boot,kpver,skey):
    os.makedirs("WorkDIR",exist_ok=True)
    os.chdir("WorkDIR")
    shutil.copyfile(boot, os.path.join(os.getcwd(), "WorkDIR", "boot.img"))
    # 获取工具
    RELEASEURL = "https://github.com/bmax121/KernelPatch/releases/tag/"+str(kpver)
    kptoolUrl = RELEASEURL+"/kptool-linux"
    urlreq.urlretrieve(kptoolUrl,"kptool")
    kpimgUrl = RELEASEURL+"/kpimg-android"
    urlreq.urlretrieve(kpimgUrl,"kpimg")
    magiskbootUrl = "https://github.com/AtopesSayuri/APatchAutoPatchTool/raw/main/bin/magiskboot"
    urlreq.urlretrieve(magiskbootUrl,"magiskboot")
    # 更改权限
    for i in ["kptool","magiskboot"]:
        os.chmod(i,0o755)
    # 解包boot
    os.system("./magiskboot unpack boot.img")
    # 修补
    os.system("./kptools -p --image kernel --skey "+skey+" --kpimg kpimg-android --out kernel")
    # 打包
    os.system("./magiskboot repack boot.img new.img")
    print("----------Done----------")

def main_page():
    prompt = "ntool - main_page\n"
    prompt += "1. 获取当前工作目录\n"
    prompt += "2. 安装shell版本\n"
    prompt += "3. 下载Python实现的Markdown转Epub程序\n"
    prompt += "0. 退出\n"
    choice = int(input(prompt))
    match choice:
        case 1:
            print(os.getcwd())
        case 2:
            print("请稍等...")
            os.system(
                "curl -s https://raw.githubusercontent.com/nnyyaa/ntool/main/install | bash -"
            )
        case 3:
            os.system("wget https://blog.nnyyaa.eu.org/files/pypandoc.py")
        case 4:
            tool_page()
        case 0:
            exit()
        case _:
            print("Something went wrong...")
            exit()

def tool_page():
    prompt = "ntool - tool_page\n"
    prompt += "1. 部分美化Termux\n"
    prompt += "2. APatch 修补功能\n"
    prompt += "0. 返回上级菜单\n"
    choice = int(input(prompt))
    match choice:
        case 0:
            main_page()
        case 1:
            os.system("curl -L https://github.com/AtopesSayuri/Small-Tools/raw/main/TermuxAutoConfig/TAC.sh | bash")
        case 2:
            BootPath = input("input boot image path: ")
            Ver = input("input KernelPatch version: ")
            SuperKey = input("input SuperKey: ")
            apatch_patch(boot=BootPath,kpver=Ver,skey=SuperKey)
        case _:
            print("Something went wrong...")
            exit()

main_page()
