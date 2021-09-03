#neovim IDE环境准备for termux
#lxyoucan@163.com
#2021年9月3日

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
if [[ "$UNAME_MACHINE" != "aarch64" ]]; then
  echo "${tty_red}安装程序只支持aarch64环境下运行${tty_reset}"
fi

echo -n "${tty_green}
欢迎使用，neovim 自动配置文件更新小助手！本脚本做以下的事情：
- 切换中科大源
- 安装git
- 安装python3
- 安装nvim+pynvim
- 安装node.js
- 安装ranger
- 安装unzip

仅支持Termux环境：
已成功测试环境：
- 坚果R1 Termux 版本0.101
${tty_reset}"
echo -n "${tty_yellow}

脚本一键安装没意思？手动安装见：
https://blog.csdn.net/lxyoucan/article/details/120077959
对您有用的放在，点赞支持一下！
${tty_blue}
1 继续安装  2 退出安装
"
# 原本这个变量是由用户输入的，为了减少用户输入操作，暂时写死了
read -r MY_DOWN_NUM
#MY_DOWN_NUM=1
echo "${tty_reset}"
case $MY_DOWN_NUM in
"1")
  MY_DIR=$(pwd)
  MY_USER=$(whoami)
  echo "${tty_green}正在设置中国科技大学源${tty_reset}"
  SOURCES_BAK="/data/data/com.termux/files/usr/etc/apt/sources.list_$(date +%Y%m%d"_"%H_%M_%S)"
  cp /data/data/com.termux/files/usr/etc/apt/sources.list "${SOURCES_BAK}"
  echo "${tty_green}原sources.list备份至
${SOURCES_BAK}
  ${tty_reset}"
  #sed -i 's@packages.termux.org@mirrors.ustc.edu.cn/termux@' $PREFIX/etc/apt/sources.list
  echo 'deb https://mirrors.ustc.edu.cn/termux/apt/termux-main stable main' > "$PREFIX/etc/apt/sources.list"
  echo "${tty_green}中国科技大学源设置完成，正在刷新缓存${tty_reset}"
  pkg up
  echo "${tty_green}正在安装python${tty_reset}"
  #python环境，因为我用到了一些需要python3支持的环境
  pkg install -y python
  #nvim不用多说
  echo "${tty_green}正在安装neovim${tty_reset}"
  pkg install -y neovim
  #git用于下载代码，和配置文件
  echo "${tty_green}正在安装git${tty_reset}"
  pkg install -y git
  #ranger我个人比较喜欢的文件管理器
  echo "${tty_green}正在安装ranger${tty_reset}"
  pkg install -y ranger
  # node.js我使用coc插件要用到，我的开发环境也用到
  echo "${tty_green}正在安装nodejs${tty_reset}"
  pkg install -y nodejs
  # 解压用，默认已经安装
  echo "${tty_green}正在安装unzip${tty_reset}"
  pkg install -y unzip
  echo "${tty_green}正在配置pip3国内源(aliyun)加速${tty_reset}"
  mkdir ~/.pip
  echo '[global]' >~/.pip/pip.conf
  echo 'index-url = https://mirrors.aliyun.com/pypi/simple' >>~/.pip/pip.conf
  echo '' >>~/.pip/pip.conf
  echo "${tty_green}安装pynvim${tty_reset}"
  pip3 install --user --upgrade pynvim
  echo "${tty_green}nodejs切换taobao源${tty_reset}"
  # 使用nrm工具切换淘宝源
  npx nrm use taobao
  echo "${tty_green}安装yarn${tty_reset}"
  npm install -g yarn
  echo "${tty_green}安装图标字体Hack Nerd Font${tty_reset}"
  curl -fLo "${XDG_DATA_HOME:-$HOME}"/.termux/font.ttf --create-dirs \
       http://ycmit.cn/files/termux/font.ttf
  #---------安装配置neovim插件 end-----------------------
  echo "${tty_green}执行完成,祝您身体健康，万事如意！
  欢迎来我的博客点赞评论，支持一波！
https://blog.csdn.net/lxyoucan/article/details/120077959

  ${tty_reset}"

  ;;

\
  "2")
  echo "
    你选择了2、取消安装
    "
  ;;
esac
