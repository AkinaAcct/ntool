import os
import sys

os.system("clear")
def main_page():
    prompt = "ntool in python\n"
    prompt += "1. 获取当前工作目录\n"
    prompt += "2. 安装shell版本\n"
    prompt += "3. 下载Python实现的Markdown转Epub程序\n"
    prompt += "0. 退出\n"
    choice = input(prompt)
    if choice == "1":
        cwd = os.getcwd()
        print(cwd)
    if choice == "2":
        print("请稍等...")
        os.system("curl -s https://raw.githubusercontent.com/nnyyaa/ntool/main/install | bash -")
    if choice== "3":
        os.system("wget https://blog.nnyyaa.eu.org/programs/pypandoc.py")
    if choice == "0":
        exit()

main_page()
