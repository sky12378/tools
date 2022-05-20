#oh my zsh插件，ITKEY个性化配置版本,CentOS7且需root权限。
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
正在安装oh my zsh插件，ITKEY个性化配置版本...
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

  #-----------判断是否已经安装了zsh------------
  #ZSH版本
  MY_ZSH=$(zsh --version)
  MY_ZSH=${MY_ZSH:0:3}
  if ! [[ "$MY_ZSH" == 'zsh' ]]; then
    #git不存在则进行安装
    echo "${tty_green}=======安装zsh=======${tty_reset}"
    yum -y install zsh
  fi
  #-----------创建用户------------
  echo "${tty_blue}请输入用户名(非root普通用户): "
  read -r MY_USER
  echo "${tty_reset}"
  echo "${tty_green}正在创建用户${MY_USER},如果用户已经存在可忽略${tty_reset}"
  adduser -s /bin/zsh "${MY_USER}"
  usermod --shell /bin/zsh "${MY_USER}"
  #-----------判断是否已经安装了git------------
  #系统版本
  MY_GIT=$(git --version)
  MY_GIT=${MY_GIT:0:3}
  if ! [[ "$MY_GIT" == 'git' ]]; then
    #zsh不存在则进行安装
    echo "${tty_green}=======安装git=======${tty_reset}"
    yum -y install git
  fi

  #备份原文件
  #备份原文件
  echo "${tty_green}尝试备份~/.zshrc${tty_reset}"
  echo "${tty_green}文件备份在：/home/${MY_USER}/.zshrc_bak_$(date +%Y%m%d"_"%H_%M_%S)${tty_reset}"
  #echo "${tty_green}文件备份在：/home/${MY_USER}/.oh-my-zsh_bak_$(date +%Y%m%d"_"%H_%M_%S)${tty_reset}"
  mv "/home/${MY_USER}/.zshrc" "/home/${MY_USER}/.zshrc_bak_$(date +%Y%m%d"_"%H_%M_%S)"
  #mv "/home/${MY_USER}/.oh-my-zsh" "/home/${MY_USER}/.oh-my-zsh_bak_$(date +%Y%m%d"_"%H_%M_%S)"
  echo "${tty_green}正在clone oh my zsh${tty_reset}"
  git clone https://codechina.csdn.net/mirrors/ohmyzsh/ohmyzsh.git "/home/${MY_USER}/.oh-my-zsh"
  echo "${tty_green}下载oh my zsh配置文件${tty_reset}"
  curl -fLo "/home/${MY_USER}/.zshrc.oh-my-zsh" https://gitee.com/lxyoucan/tools/raw/master/common/.zshrc.oh-my-zsh
  echo "${tty_green}下载oh my zsh 语法高亮插件${tty_reset}"
  git clone https://codechina.csdn.net/mirrors/zsh-users/zsh-syntax-highlighting.git "/home/${MY_USER}/.oh-my-zsh/plugins/zsh-syntax-highlighting"
  echo "${tty_green}下载oh my zsh 自动补全插件${tty_reset}"
  git clone https://codechina.csdn.net/mirrors/zsh-users/zsh-autosuggestions.git "/home/${MY_USER}/.oh-my-zsh/plugins/zsh-autosuggestions"

  echo "#加载oh my zsh插件" >"/home/${MY_USER}/.zshrc"
  echo "source ~/.zshrc.oh-my-zsh" >>"/home/${MY_USER}/.zshrc"
  #文件授权
  chown -R "${MY_USER}" "/home/${MY_USER}/.oh-my-zsh/"
  chown -R "${MY_USER}" "/home/${MY_USER}/.zshrc"
  chown -R "${MY_USER}" "/home/${MY_USER}/.zshrc.oh-my-zsh"

  echo "${tty_cyan}-------------------------使用帮助-------------------------${tty_reset}"
  echo "${tty_cyan}已经成功安装在${tty_blue} /home/${MY_USER}/.oh-my-zsh${tty_reset}"
  echo "${tty_cyan}oh my zsh配置文件在${tty_blue} /home/${MY_USER}/.zshrc.oh-my-zsh${tty_reset}"
  echo "${tty_cyan}zsh配置文件在${tty_blue}/home/${MY_USER}/.zshrc${tty_reset}"
  echo "${tty_cyan}
以下方法可以看到效果：
- ${MY_USER}重新登录shell 或者
- root用户执行：
${tty_blue}su ${MY_USER}${tty_cyan}
- 或者${MY_USER}用户登录执行下面命令立即生效：
${tty_blue}source ~/.zshrc${tty_cyan}
备份的文件请自行决定是否删除。
${tty_reset}"

  echo "${tty_cyan}-------------------------使用帮助-------------------------${tty_reset}"
  echo "${tty_green}oh my zsh 已经安装完成,祝您身体健康，万事如意！${tty_reset}"
  ;;

\
  "2")
  echo "
    你选择了2、取消安装
    "
  ;;
esac
