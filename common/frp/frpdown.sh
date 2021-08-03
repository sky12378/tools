#Frp linux客户端下载
#lxyoucan@163.com
#2021年8月3日

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
  echo "${tty_red}安装程序只支持linux环境下运行${tty_reset}"
fi

echo -n "${tty_green}
frp_0.37.0_linux_amd64.tar.gz 下载脚本
${tty_reset}"

# 原本这个变量是由用户输入的，为了减少用户输入操作，暂时写死了
#read -r MY_DOWN_NUM
MY_DOWN_NUM=1
echo "${tty_reset}"
case $MY_DOWN_NUM in
"1")
  MY_DIR=$(pwd)

  #-----------判断是否已经安装了git------------
  #系统版本
  MY_GIT=$(git --version)
  MY_GIT=${MY_GIT:0:3}
  if ! [[ "$MY_GIT" == 'git' ]]; then
    #非CentOS7没有安装git
    if ! [[ "$MY_REDHAT_RELEASE" == 'CentOS Linux release 7' ]]; then
      echo "${tty_red}git程序没有安装，程序退出${tty_reset}"
      exit
    fi
    #zsh不存在则进行安装
    echo "${tty_green}=======安装git=======${tty_reset}"
    yum -y install git
  fi

  #检查安装包是否已经存在，如果存在则不重新下载安装包了(优化多次运行脚本的体验)
  if [ ! -f "/tmp/frpdown/common/frp/frp_0.37.0_linux_amd64.tar.gz" ]; then
    echo "${tty_green}=======正在下载frp=======${tty_reset}"
    cd /tmp/
    #创建下载目录
    mkdir frpdown
    #初始化空仓库
    cd frpdown
    git init
    #关联远程地址
    git remote add -f origin https://gitee.com/lxyoucan/tools.git
    #开启Sparse Checkout模式
    git config core.sparsecheckout true
    #设置需Check Out的文件
    echo "common/frp" >>.git/info/sparse-checkout
    #Check Out
    git pull origin master
    cd "$MY_DIR"
  fi

  cp /tmp/frpdown/common/frp/frp_0.37.0_linux_amd64.tar.gz "$MY_DIR"
  echo "${tty_green}frp_0.37.0_linux_amd64.tar.gz下载完成,祝您身体健康，万事如意！${tty_reset}"

  ;;

\
  "2")
  echo "
    你选择了2、取消安装
    "
  ;;
esac
