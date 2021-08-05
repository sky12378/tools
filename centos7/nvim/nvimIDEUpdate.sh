#同步neovim的配置文件
#lxyoucan@163.com
#2021年8月5日

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

echo -n "${tty_green}
欢迎使用，neovim 配置文件更新小助手！本脚本做以下的事情：
仅用于更新由
sh -c \"\$(curl -fsSL https://gitee.com/lxyoucan/tools/raw/master/centos7/nvim/nvimIDE.sh)\"
搭建的环境，更新相关的配置文件和插件。
只会更新当前用户~/.config/nvim 目录中的文件
没有执行上面脚本的朋友，不要执行此脚本。

测试环境为：MacOS 11.4 | CentOS Linux release 7.9.2009 (Core)。
须要满足以下条件才可以使用${tty_reset}"
echo -n "${tty_yellow}
- 此脚本普通用户执行即可
- 此脚本仅在CentOS7下测试，不一定兼容其他平台
${tty_red}
警告：
脚本会覆盖安装用户以下目录
.config/nvim
会自动备份。
"
# 原本这个变量是由用户输入的，为了减少用户输入操作，暂时写死了
#read -r MY_DOWN_NUM
MY_DOWN_NUM=1
echo "${tty_reset}"
case $MY_DOWN_NUM in
"1")
  MY_DIR=$(pwd)
  MY_USER=$(whoami)
  MY_CP='"${MY_CP}"'
  # 判断是Linux还是Mac os
  OS="$(uname)"
  if [[ "$OS" != "Linux" ]]; then
    #macOS中cp命令路径不同
    MY_CP='/bin/cp'
  fi

  #-----------判断是否已经安装了git------------
  #git版本
  MY_GIT=$(git --version)
  MY_GIT=${MY_GIT:0:3}
  if ! [[ "$MY_GIT" == 'git' ]]; then
    echo "${tty_red}git未安装，程序退出！${tty_reset}"
    exit
  fi

  #unzip版本
  MY_UNZIP=$(unzip --help)
  MY_UNZIP=${MY_UNZIP:0:5}
  if ! [[ "$MY_UNZIP" == 'UnZip' ]]; then
    echo "${tty_red}unzip未安装，程序退出！${tty_reset}"
    exit
  fi

  echo "${tty_green}=======当前用户是${MY_USER}=======${tty_reset}"

  #检查安装包是否已经存在，如果存在则不重新下载安装包了(优化多次运行脚本的体验)
  if [ ! -f "$HOME/.nvimupdate/centos7/nvim/home/.config/nvim/init.vim" ]; then
    echo "${tty_green}=======正在下载neovim 配置文件=======${tty_reset}"
    cd "$HOME/"
    #创建下载目录
    mkdir .nvimupdate
    #初始化空仓库
    cd .nvimupdate
    git init
    #关联远程地址
    git remote add -f origin https://gitee.com/lxyoucan/tools.git
    #开启Sparse Checkout模式
    git config core.sparsecheckout true
    #设置需Check Out的文件
    echo "centos7/nvim/home/.config/" >>.git/info/sparse-checkout
    #Check Out
    git pull origin master
    cd "$MY_DIR"
  fi

  cd "$HOME/.nvimupdate"
  #更新代码
  git pull origin master

  #---------安装配置neovim插件 start-----------------------
  #备份
  MY_NVIM_BAK="$HOME/.config/nvim_bak_$(date +%Y%m%d"_"%H_%M_%S)"
  mv "$HOME/.config/nvim" "${MY_NVIM_BAK}"
  echo "${tty_green}$HOME/.config/nvim 目录已经更新${tty_reset}"
  "${MY_CP}" -rf "$HOME/.nvimupdate/centos7/nvim/home/.config/nvim" "$HOME/.config/"
  "${MY_CP}" -rf "$HOME/.nvimupdate/centos7/nvim/home/.config/coc.zip" "$HOME/.config/"
  #解压文件
  cd "$HOME/.config/nvim"
  unzip -oq plugged.zip
  #删除压缩包
  rm -rf plugged.zip

  cd "$HOME/.config/"
  unzip -oq coc.zip
  rm -rf coc.zip
  echo "${tty_green}$HOME/.config/coc 目录已经更新${tty_reset}"
  cd "$MY_DIR"

  chown -R "${MY_USER}" "$HOME/.config/"

  #---------安装配置neovim插件 end-----------------------

  echo "${tty_green}文件备份：${MY_NVIM_BAK}${tty_reset}"
  echo "${tty_green}更新完成,祝您身体健康，万事如意！${tty_reset}"

  ;;

\
  "2")
  echo "
    你选择了2、取消安装
    "
  ;;
esac
