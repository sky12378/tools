#node14自动安装脚本
#lxyoucan@163.com
#2021年11月30日

# 字符串染色程序
if [[ -t 1 ]]; then
  tty_escape() { printf "\033[%sm" "$1"; }
else
  tty_escape() { :; }
fi
tty_universal() { tty_escape "0;$1"; } #正常显示
tty_mkbold() { tty_escape "1;$1"; }    #设置高亮
tty_underline="$(tty_escape "4;39")"   #下划线
tty_blue="$(tty_universal 34)"         #蓝色
tty_red="$(tty_universal 31)"          #红色
tty_green="$(tty_universal 32)"        #绿色
tty_yellow="$(tty_universal 33)"       #黄色
tty_bold="$(tty_universal 39)"         #加黑
tty_cyan="$(tty_universal 36)"         #青色
tty_reset="$(tty_escape 0)"            #去除颜色

#获取硬件信息
UNAME_MACHINE="$(uname -m)"
if [[ "$UNAME_MACHINE" != "x86_64" ]]; then
  echo "${tty_red}安装程序只支持x86_64环境下运行${tty_reset}"
fi
# 判断是Linux还是Mac os
OS="$(uname)"
if [[ "$OS" != "Linux" ]]; then
  echo "${tty_red}当前系统是：${OS},安装程序只支持linux环境下运行${tty_reset}"
fi

echo -n "${tty_green}
欢迎使用，node.js 14安装小助手！
By:ITKEY 日期：2021-11-30
博客：https://blog.csdn.net/lxyoucan
本脚本用于自动下载安装node.js，因为一些发行版本的软件管理器无法安装新版node.js。比如：银河麒麟桌面操作系统V10 (SP1)
须要满足以下条件才可以使用${tty_reset}"
echo -n "${tty_yellow}
请保存已经成功安装了下面的软件：
- wget
${tty_blue}
当前系统的架构是：${UNAME_MACHINE}
请输入你要安装的系统架构：
1. x86_64    2.ARMv7     3.ARMv8
"
#-----------判断是否已经安装了wget------------
NODE_TAR_NAME='noselect'
MY_WGET=$(wget --version)
MY_WGET=${MY_WGET:0:3}
if ! [[ "$MY_WGET" == 'GNU' ]]; then
  echo "${tty_red}wget未安装，程序退出！${tty_reset}"
  exit
fi
# 原本这个变量是由用户输入的，为了减少用户输入操作，暂时写死了
read -r MY_DOWN_NUM
#MY_DOWN_NUM=1
echo "${tty_reset}"
case $MY_DOWN_NUM in
"1")
  echo "你选择了1、 node-v14.18.1-linux-x64"
  NODE_TAR_NAME='node-v14.18.1-linux-x64'
  ;;
"2")
  echo "你选择了2、node-v14.18.1-linux-armv7l"
  NODE_TAR_NAME='node-v14.18.1-linux-armv7l'
  ;;
"3")
  echo "你选择了3、node-v14.18.1-linux-arm64"
  NODE_TAR_NAME='node-v14.18.1-linux-arm64'
  ;;
esac
if ! [[ "$NODE_TAR_NAME" == 'noselect' ]]; then
  echo "${tty_green}-----------准备开始安装$NODE_TAR_NAME-----------${tty_reset}"
  wget "https://npmmirror.com/mirrors/node/v14.18.1/${NODE_TAR_NAME}.tar.xz"
  mkdir -p ~/.soft/
  tar -vxf "${NODE_TAR_NAME}.tar.xz"
  mv "${NODE_TAR_NAME}" ~/.soft/
  echo "export PATH=${HOME}/.soft/${NODE_TAR_NAME}/bin:"'$PATH' >> ~/.bashrc
  echo "${tty_green}
安装路径：
${HOME}/.soft/${NODE_TAR_NAME}/
环境变量：
配置已经自动增加到~/.bashrc"
  echo "内容如下：${tty_blue}
export PATH=${HOME}/.soft/${NODE_TAR_NAME}/bin:"'$PATH'
  echo "${tty_green}如果不是bash请自行调整，比如：zsh配置文件就对应~/.zshrc
手动执行：${tty_blue}
source ~/.bashrc
${tty_green}使配置立马生效。${tty_reset}"
  echo "${tty_green}安装完成，来点个赞吧！https://blog.csdn.net/lxyoucan/article/details/121644291${tty_blue}"
  exit
fi
