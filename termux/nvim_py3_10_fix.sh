#修复nvim0.5.1 无法使用python3.10的BUG
#lxyoucan@163.com
#2021年10月10日

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
欢迎使用nvim0.5.1补丁!本脚本做以下的事情：
修复nvim0.5.1 无法使用python3.10 的BUG
此BUG可能会在nvim0.5.1后续版本中，官方自动修复。

使用前请确认

仅支持Termux环境：
已成功测试环境：
- 坚果R1 Termux 版本0.117
${tty_reset}"
echo -n "${tty_yellow}

脚本一键安装没意思？手动安装见：
https://blog.csdn.net/lxyoucan/article/details/120684804
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
  echo "${tty_green}修复nvim0.5.1 无法使用python3.10的BUG${tty_reset}"
  SOURCES_BAK="/data/data/com.termux/files/usr/share/nvim/runtime/autoload/provider/pythonx.vim_$(date +%Y%m%d"_"%H_%M_%S)"
  cp /data/data/com.termux/files/usr/share/nvim/runtime/autoload/provider/pythonx.vim "${SOURCES_BAK}"
  echo "${tty_green}原pythonx.vim备份至
${SOURCES_BAK}
  ${tty_reset}"
  curl -fLo /data/data/com.termux/files/usr/share/nvim/runtime/autoload/provider/pythonx.vim --create-dirs \
         https://gitee.com/lxyoucan/tools/raw/master/termux/pythonx.vim
  echo "${tty_green}执行完成,祝您身体健康，万事如意！
  欢迎来我的博客点赞评论，支持一波！
https://blog.csdn.net/lxyoucan/article/details/120684804

  ${tty_reset}"
  ;;

\
  "2")
  echo "
    你选择了2、取消安装
    "
  ;;
esac
