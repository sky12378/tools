#oh my zsh插件，ITKEY个性化配置版本,无需root权限。
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

echo -n "${tty_green}
正在安装oh my zsh插件，ITKEY个性化配置版本...
安装插件需要以下条件：
- zsh
- git
请自行安装，示例（CentOS7）：
yum -y install zsh git

${tty_blue}

1、继续安装    2、退出安装
"
# 原本这个变量是由用户输入的，为了减少用户输入操作，暂时写死了
read -r MY_DOWN_NUM
echo "${tty_reset}"
case $MY_DOWN_NUM in
"1")

  #判断是否已经安装了git
  #系统版本
  MY_GIT=$(git --version)
  MY_GIT=${MY_GIT:0:3}
  if ! [[ "$MY_GIT" == 'git' ]]; then
    #node不存在则进行安装
    echo "${tty_red}=======git不存在，程序退出=======${tty_reset}"
    exit
  fi
  #备份原文件
  echo "${tty_green}尝试备份~/.zshrc|~/.oh-my-zsh${tty_reset}"
  mv ~/.zshrc "${HOME}/.zshrc_bak_$(date +%Y%m%d"_"%H_%M_%S)"
  mv ~/.oh-my-zsh "${HOME}/.oh-my-zsh_bak_$(date +%Y%m%d"_"%H_%M_%S)"
  echo "${tty_green}正在clone oh my zsh${tty_reset}"
  git clone https://codechina.csdn.net/mirrors/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
  echo "${tty_green}下载oh my zsh配置文件${tty_reset}"
  curl -fLo ~/.zshrc.oh-my-zsh https://gitee.com/lxyoucan/tools/raw/master/common/.zshrc.oh-my-zsh
  echo "${tty_green}下载oh my zsh 语法高亮插件${tty_reset}"
  git clone https://codechina.csdn.net/mirrors/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
  echo "${tty_green}下载oh my zsh 自动补全插件${tty_reset}"
  git clone https://codechina.csdn.net/mirrors/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/plugins/zsh-autosuggestions

  echo "#加载oh my zsh插件" >~/.zshrc
  echo "source ~/.zshrc.oh-my-zsh" >~/.zshrc
  echo "${tty_blue}oh my zsh 已经安装完成。
请自己安装zsh
例如：CentOS中:
yum -y install zsh
设置默认zsh:
chsh -s /usr/bin/zsh
执行下面命令立即生效：
source ~/.zshrc
备份的文件请自行决定是否删除。
${tty_reset}"

  ;;

\
  "2")
  echo "
    你选择了2、取消安装
    "
  ;;
esac
