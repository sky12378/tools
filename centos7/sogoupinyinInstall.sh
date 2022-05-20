#CentOS7搜狗输入法自动安装脚本
#lxyoucan@163.com


# 字符串染色程序
if [[ -t 1 ]]; then
  tty_escape() { printf "\033[%sm" "$1"; }
else
  tty_escape() { :; }
fi
tty_universal() { tty_escape "0;$1"; } #正常显示
tty_mkbold() { tty_escape "1;$1"; } #设置高亮
tty_underline="$(tty_escape "4;39")" #下划线
tty_blue="$(tty_universal 34)" #蓝色
tty_red="$(tty_universal 31)" #红色
tty_green="$(tty_universal 32)" #绿色
tty_yellow="$(tty_universal 33)" #黄色
tty_bold="$(tty_universal 39)" #加黑
tty_cyan="$(tty_universal 36)" #青色
tty_reset="$(tty_escape 0)" #去除颜色


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
欢迎使用，CentOS7安装搜狗输入法小助手！本助手为了简化CentOS7中安装搜狗输入法而生。
测试环境为：CentOS Linux release 7.9.2009 (Core)，理论上支持CentOS7。
手动安装教程：https://blog.csdn.net/lxyoucan/article/details/119119392
须要满足以下条件才可以使用${tty_reset}"
echo -n "${tty_yellow}
- 确定你已经成功安装Fcitx输入法框架
- 此脚本需要root权限运行
- 此脚本仅在CentOS7下有效
${tty_reset}"
if [[ -z "${HOMEBREW_ON_LINUX-}" ]]; then
#mac才显示腾讯 阿里，他们对linux目前支持很差
    echo "${tty_green} 1、继续安装 2、取消安装 ${tty_reset} "
fi
echo -n "
${tty_blue}请输入序号: "
read MY_DOWN_NUM
echo "${tty_reset}"
case $MY_DOWN_NUM in
"1")
    echo "
    你选择了1、继续安装
    "
    echo "${tty_green}正在安装依赖${tty_reset}"
    yum -y install qtwebkit
    yum -y install dpkg
    yum -y install alien
    #添加QT依赖
    yum -y install fcitx-qt5 fcitx-configtool
    yum -y install wget
    echo "${tty_green}正在下载搜狗输入法${tty_reset}"
    wget http://cdn2.ime.sogou.com/dl/index/1524572264/sogoupinyin_2.2.0.0108_amd64.deb
    echo "${tty_green}正在转换安装包${tty_reset}"
    alien -r --scripts sogoupinyin_2.2.0.0108_amd64.deb
    echo "${tty_green}正在安装搜狗输入法${tty_reset}"
    rpm -ivh --force sogoupinyin-2.2.0.0108-2.x86_64.rpm
    echo "${tty_green}正在配置搜狗输入法${tty_reset}"
    cp /usr/lib/x86_64-linux-gnu/fcitx/fcitx-sogoupinyin.so /usr/lib64/fcitx/
    #修改权限
    chown -R 776 /usr/share/fcitx-sogoupinyin/
    echo -n "${tty_green}
搜狗输入法安装配置完成,重启fcitx输入法框架，或者注销、重启。然后就可以正常使用搜狗输入法了。
手动重启fcitx输入法框架，执行以下命令：${tty_reset}"

    echo -n "${tty_yellow}
fcitx -r; fcitx-configtool
${tty_reset}"
    echo "第一次切换到搜狗输入法，会初始化所以会比较慢。  enjoy!"

;;
"2")
    echo "
    你选择了2、取消安装
    "
;;
esac
