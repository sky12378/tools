#CentOS7且需root权限,tmux编译安装新版本
#lxyoucan@163.com

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

MY_WHO_AM_I=$(whoami)
#系统版本
MY_REDHAT_RELEASE=$(cat /etc/redhat-release)
MY_REDHAT_RELEASE=${MY_REDHAT_RELEASE:0:22}
if ! [[ "$MY_REDHAT_RELEASE" == 'CentOS Linux release 7' ]]; then
  echo "${tty_red}友情提醒：脚本只适用于CentOS Linux release 7，程序退出${tty_reset}"
  exit
fi

#判断是否是root用户，如果不是则退出脚本
if ! [[ "$MY_WHO_AM_I" =~ ^root$ ]]; then
  echo "${tty_red}友情提醒：当前用户${MY_WHO_AM_I}不是root用户，权限不足，程序退出${tty_reset}"
  exit
fi

echo -n "${tty_green}
yum 安装的tmux版本太低，一些特性无法使用，所以编译安装新版本的。
正在编译安装tmux最新版本+ITKEY个性化配置...
安装插件需要以下条件：
- 脚本只在CentOS7下测试运行，不支持其他平台
- 脚本需要root权限执行

${tty_blue}

1、继续安装    2、退出安装
"
# 原本这个变量是由用户输入的，为了减少用户输入操作，暂时写死了
read -r MY_DOWN_NUM
echo "${tty_reset}"
case $MY_DOWN_NUM in
"1")

  MY_DIR=$(pwd)
  echo "${tty_cyan}============编译环境依赖安装git,gcc,gcc-c++,ncurses-devel等等============${tty_reset}"
  yum install git -y
  yum install gcc gcc-c++ -y
  yum install ncurses-devel -y
  yum install -y automake
  yum install -y openssl-devel
  yum install -y glibc-static
  yum install -y bison

  #检查安装包是否已经存在，如果存在则不重新下载安装包了(优化多次运行脚本的体验)
  if [ ! -f "/tmp/nvimdown/centos7/tmux/libevent-2.1.12-stable.tar.gz" ]; then
    echo "${tty_cyan}============正在下载libevent 2.1.12源码包============${tty_reset}"
    cd /tmp/
    #创建下载目录
    mkdir nvimdown
    #初始化空仓库
    cd nvimdown
    git init
    #关联远程地址
    git remote add -f origin https://gitee.com/lxyoucan/tools.git
    #开启Sparse Checkout模式
    git config core.sparsecheckout true
    #设置需Check Out的文件
    echo "centos7/tmux" >>.git/info/sparse-checkout
    #Check Out
    git pull origin master
    cd "$MY_DIR"
  fi

  cd /tmp/nvimdown/centos7/tmux/
  tar -xzvf libevent-2.1.12-stable.tar.gz
  cd libevent-2.1.12-stable
  ./configure &
  make -j8
  sudo make install
  cd "$MY_DIR"

  echo "${tty_cyan}============正在下载tmux的源码============${tty_reset}"
  git clone https://codechina.csdn.net/mirrors/tmux/tmux.git
  cd tmux
  sh autogen.sh
  echo "${tty_cyan}============正在编译安装tmux============${tty_reset}"
  ./configure && make -j8
  sudo make install
  echo "${tty_cyan}============添加libevent_core-2.1.so.7到/lib64/目录============${tty_reset}"
  cp /usr/local/lib/libevent_core-2.1.so.7 /lib64/
  echo "${tty_cyan}============检测tmux版本============${tty_reset}"
  tmux -V

  echo "${tty_cyan}-------------------------使用帮助-------------------------${tty_reset}"

  echo "${tty_cyan}-------------------------使用帮助-------------------------${tty_reset}"
  echo "${tty_green}tmux已经安装完成,祝您身体健康，万事如意！${tty_reset}"
  ;;

\
  "2")
  echo "
    你选择了2、取消安装
    "
  ;;
esac
