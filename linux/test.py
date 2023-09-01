import os

os.system("clear")
def main_page():
    prompt = "ntool Python实现测试版\n"
    prompt += "1. 获取当前工作目录\n"
    prompt += "2. 安装shell版本\n"
    prompt += "0. 退出\n"
    choice = input(prompt)
    if choice == "1":
        cwd = os.getcwd()
        print(cwd)
    if choice == "2":
        os.system("curl -s https://raw.githubusercontent.com/nnyyaa/ntool/main/install | bash -")
    if choice == "0":
        exit()

main_page()
