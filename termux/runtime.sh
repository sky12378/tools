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

须要满足以下条件才可以使用${tty_reset}"
echo -n "${tty_yellow}
请保存已经成功安装了下面的软件：

脚本一键安装没意思？手动安装见：
https://blog.csdn.net/lxyoucan/article/details/120077959
对您有用的放在，点赞支持一下！
"
# 原本这个变量是由用户输入的，为了减少用户输入操作，暂时写死了
#read -r MY_DOWN_NUM
MY_DOWN_NUM=1
echo "${tty_reset}"
case $MY_DOWN_NUM in
"1")
  MY_DIR=$(pwd)
  MY_USER=$(whoami)
  echo "${tty_green}正在设置中国科技大学源${tty_reset}"
  SOURCES_BAK="/data/data/com.termux/files/usr/etc/apt/sources.list_$(date +%Y%m%d"_"%H_%M_%S)"
  mv /data/data/com.termux/files/usr/etc/apt/sources.list "${SOURCES_BAK}"
  echo "${tty_green}原sources.list备份至
${SOURCES_BAK}
  ${tty_reset}"



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
