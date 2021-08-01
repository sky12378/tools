#CentOS7搭建nvim开发环境
# - neovim
# - nvim-coc
#lxyoucan@163.com
#2021年7月31日

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

#选择一个下载源
echo -n "${tty_green}
欢迎使用，CentOS7安装neovim react typescript开发环境小助手！本脚本做以下的事情：
- neovim安装
- python3安装
- node.js安装

测试环境为：CentOS Linux release 7.9.2009 (Core)。
须要满足以下条件才可以使用${tty_reset}"
echo -n "${tty_yellow}
- 此脚本需要root权限运行
- 此脚本仅在CentOS7下有效
${tty_red}
警告：
脚本会覆盖安装用户以下目录
.config/ranger
.config/nvim
如果这些目录中已经有文件请自行手动备份。
${tty_blue}

1、继续安装    2、退出安装
"
# 原本这个变量是由用户输入的，为了减少用户输入操作，暂时写死了
read -r MY_DOWN_NUM
echo "${tty_reset}"
case $MY_DOWN_NUM in
"1")
  MY_DIR=$(pwd)
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

  echo "${tty_blue}请输入用户名(非root普通用户): "
  read -r MY_USER
  echo "${tty_reset}"
  echo "${tty_green}正在创建用户${MY_USER},如果用户已经存在可忽略${tty_reset}"
  adduser "${MY_USER}"
  echo "${tty_green}=======正在安装git=======${tty_reset}"
  yum -y install git
  yum -y install unzip
  #检查安装包是否已经存在，如果存在则不重新下载安装包了(优化多次运行脚本的体验)
  if [ ! -f "/tmp/nvimdown/centos7/nvim/nvim-linux64-v0.5.0.tar.gz" ]; then
    echo "${tty_green}=======正在下载neovim=======${tty_reset}"
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
    echo "centos7/nvim" >>.git/info/sparse-checkout
    #Check Out
    git pull origin master
    cd "$MY_DIR"
  fi

  #---------安装neovim start-----------------------
  echo "${tty_green}=======正在安装neovim=======${tty_reset}"
  cd "$MY_DIR"
  cd /tmp/nvimdown/centos7/nvim/
  #解压
  tar -xf nvim-linux64-v0.5.0.tar.gz
  mv nvim-linux64 /usr/local/
  #创建软链接
  ln -s /usr/local/nvim-linux64/bin/nvim /bin/nvim
  echo "${tty_green}=======检查neovim版本=======${tty_reset}"
  nvim --version
  echo "${tty_green}=======安装python3=======${tty_reset}"
  yum install python3 python3-devel -y
  echo "${tty_green}=======增加neovim python3支持=======${tty_reset}"
  runuser -l "${MY_USER}" -c 'pip3 install --user --upgrade pynvim -i https://mirrors.aliyun.com/pypi/simple/'
  #---------安装neovim end-----------------------

  #---------安装配置ranger start-----------------------
  echo "${tty_green}=======安装ranger=======${tty_reset}"
  runuser -l "${MY_USER}" -c 'pip3 install --user --upgrade ranger-fm -i https://mirrors.aliyun.com/pypi/simple/'
  echo "${tty_green}=======配置ranger=======${tty_reset}"
  mkdir -p "/home/${MY_USER}/.config/ranger"
  /usr/bin/cp -rf "/tmp/nvimdown/centos7/nvim/home/.config/ranger" "/home/${MY_USER}/.config/"
  echo "${tty_green}=======安装highlight=======${tty_reset}"
  yum -y install highlight
  chown -R "${MY_USER}" "/home/${MY_USER}/.config/"
  #---------安装配置ranger end-----------------------

  #---------安装配置neovim插件 start-----------------------
  echo "${tty_green}=======安装配置neovim插件=======${tty_reset}"
  #安装neovim插件管理器vim-plug 从csdn镜像加速
  #curl -fLo "/home/${MY_USER}/.local/share/nvim/site/autoload/plug.vim" --create-dirs https://codechina.csdn.net/mirrors/junegunn/vim-plug/-/raw/master/plug.vim

  #创建目录
  mkdir -p "/home/${MY_USER}/.local/share/nvim/site/autoload"
  #安装vim-plug插件管理器，从自己的版本管理，兼容性可能会更高一些
  /usr/bin/cp -rf "/tmp/nvimdown/centos7/nvim/home/.local/share/nvim/site/autoload/plug.vim" "/home/${MY_USER}/.local/share/nvim/site/autoload/"
  #安装rplugin.vim
  /usr/bin/cp -rf "/tmp/nvimdown/centos7/nvim/home/.local/share/nvim/rplugin.vim" "/home/${MY_USER}/.local/share/nvim/"
  #替换文件中的<USER>标签为当前用户
  sed -i "s/<USER>/${MY_USER}/g" "/home/${MY_USER}/.local/share/nvim/rplugin.vim"
  chown -R "${MY_USER}" "/home/${MY_USER}/.local/"
  /usr/bin/cp -rf "/tmp/nvimdown/centos7/nvim/home/.config/nvim" "/home/${MY_USER}/.config/"
  /usr/bin/cp -rf "/tmp/nvimdown/centos7/nvim/home/.config/coc.zip" "/home/${MY_USER}/.config/"
  #解压文件
  cd "/home/${MY_USER}/.config/nvim"
  unzip -oq plugged.zip
  #删除压缩包
  rm -rf plugged.zip

  cd "/home/${MY_USER}/.config/"
  unzip -oq coc.zip
  rm -rf coc.zip
  cd "$MY_DIR"

  chown -R "${MY_USER}" "/home/${MY_USER}/.config/"

  #安装node.js
  #系统版本
  MY_NODE=$(node -v)
  MY_NODE=${MY_NODE:0:2}
  if ! [[ "$MY_NODE" == 'v1' ]]; then
    #node不存在则进行安装
    echo "${tty_green}=======安装node.js 14=======${tty_reset}"
    curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
    sudo yum install nodejs -y
    # node.js使用taobao源
    echo "${tty_green}=======node.js使用taobao源=======${tty_reset}"
    npx nrm use taobao
  fi

  #---------安装配置neovim插件 start-----------------------

  ;;

\
  "2")
  echo "
    你选择了2、取消安装
    "
  ;;
esac
