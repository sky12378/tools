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
欢迎使用，neovim 自动配置文件更新小助手！本脚本做以下的事情：
- 为neovim安装 vim-plug插件管理
- 安装（或者更新）当前用户~/.config/nvim 目录中的文件
- 安装（或者更新）当前用户~/.config/ranger 目录中的文件
- 安装（已存在则跳过）~/.local/share/nvim/site/autoload/plug.vim

理论上支持所有的Linux环境：
已成功测试环境：
- MacOS 11.4
- CentOS Linux release 7.9.2009 (Core)
- Termux
- WSL Ubuntu 20.04

须要满足以下条件才可以使用${tty_reset}"
echo -n "${tty_yellow}
请保存已经成功安装了下面的软件：
- git
- python3
- nvim+pynvim
- node.js
- ranger
- unzip
以上软件的安装方法在各发布版本中略有不同，为了方便大家，我专门把我实践过的发行版本安装方法汇总到下面文章之中了。
https://blog.csdn.net/lxyoucan/article/details/120077959
对您有用的放在，点赞支持一下！
${tty_red}
文件备份提醒：
脚本会覆盖安装用户以下目录或文件(自动备份在相同的目录)
- ~/.config/nvim
- ~/.config/nvim
- ~/.local/share/nvim/site/autoload/plug.vim
- ~/.local/share/nvim/rplugin.vim
"
# 原本这个变量是由用户输入的，为了减少用户输入操作，暂时写死了
#read -r MY_DOWN_NUM
MY_DOWN_NUM=1
echo "${tty_reset}"
case $MY_DOWN_NUM in
"1")
  MY_DIR=$(pwd)
  MY_USER=$(whoami)
  MY_CP='/usr/bin/cp'
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
  #检查plug.vim是否已经存在，如果存在则不重新下载安装包了(优化多次运行脚本的体验)
  if [ ! -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]; then
    echo "${tty_green}=======正在下载vim plug插件=======${tty_reset}"
    # 安装 vim plug插件
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://gitee.com/lxyoucan/tools/raw/master/centos7/nvim/home/.local/share/nvim/site/autoload/plug.vim'
  fi


  #备份
  echo "${tty_green}=======正在备份文件=======${tty_reset}"
  mkdir -p "$HOME/.nvimIDE_bak/.config/"
  mkdir -p "$HOME/.nvimIDE_bak/.local/share/nvim/"
  MY_NVIM_BAK="$HOME/.nvimIDE_bak/.config/nvim_bak_$(date +%Y%m%d"_"%H_%M_%S)"
  MY_COC_BAK="$HOME/.nvimIDE_bak/.config/coc_bak_$(date +%Y%m%d"_"%H_%M_%S)"
  MY_RANGER_BAK="$HOME/.nvimIDE_bak/.config/ranger_bak_$(date +%Y%m%d"_"%H_%M_%S)"
  MY_RPLUGIN_BAK="$HOME/.nvimIDE_bak/.local/share/nvim/rplugin.vim_bak_$(date +%Y%m%d"_"%H_%M_%S)"
  mv "$HOME/.config/nvim" "${MY_NVIM_BAK}"
  mv "$HOME/.config/coc" "${MY_COC_BAK}"
  mv "$HOME/.config/ranger" "${MY_RANGER_BAK}"
  mv "$HOME/.local/share/nvim/rplugin.vim" "${MY_RPLUGIN_BAK}"

  echo "${tty_green}=======下载 rplugin.vim配置文件=======${tty_reset}"
  # 下载 rplugin.vim配置文件
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/rplugin.vim --create-dirs \
       https://gitee.com/lxyoucan/tools/raw/master/centos7/nvim/home/.local/share/nvim/rplugin.vim'
  # 修改配置文件中的<USER>为当前的用户名
  #sed -i "s/<USER>/${USER}/g" "${HOME}/.local/share/nvim/rplugin.vim"
  sed -i "s#/home/<USER>#$HOME#g" "${HOME}/.local/share/nvim/rplugin.vim"


  echo "${tty_green}$HOME/.config/nvim 目录已经更新${tty_reset}"
  echo "${tty_green}$HOME/.config/ranger 目录已经更新${tty_reset}"
  mkdir -p "$HOME/.config/"
  "${MY_CP}" -rf "$HOME/.nvimupdate/centos7/nvim/home/.config/nvim" "$HOME/.config/"
  "${MY_CP}" -rf "$HOME/.nvimupdate/centos7/nvim/home/.config/coc.zip" "$HOME/.config/"
  "${MY_CP}" -rf "$HOME/.nvimupdate/centos7/nvim/home/.config/ranger" "$HOME/.config/"
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

  #chown -R "${MY_USER}" "$HOME/.config/"

  #---------安装配置neovim插件 end-----------------------

  echo "${tty_green}文件备份：
${MY_NVIM_BAK}
${MY_COC_BAK}
${MY_RANGER_BAK}
${MY_RPLUGIN_BAK}
${tty_reset}"
  echo "${tty_green}更新完成,祝您身体健康，万事如意！${tty_reset}"

  ;;

\
  "2")
  echo "
    你选择了2、取消安装
    "
  ;;
esac
