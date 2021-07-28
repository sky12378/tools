#CentOS7安装Xfce桌面+配置vncserver+Fcitx输入法+搜狗输入
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
欢迎使用，CentOS7安装xfce+Vnc小助手！本脚本做以下的事情：
- 安装tigervnc-server
- 配置vncserver
- 开放防火墙5901端口
- 安装fcitx输入法
- 安装搜狗输入法

测试环境为：CentOS Linux release 7.9.2009 (Core)。
手动安装教程：https://blog.csdn.net/lxyoucan/article/details/113205625
须要满足以下条件才可以使用${tty_reset}"
echo -n "${tty_yellow}
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
    echo "${tty_blue}请输入用于连接vnc的用户名: "
      read MY_VNC_USER
    echo "${tty_reset}"
    echo "${tty_green}正在安装tigervnc-server${tty_reset}"
    yum -y install tigervnc-server
    echo "${tty_green}您输入的用户名是:${MY_VNC_USER}${tty_reset}"
    echo "${tty_green}正在创建用户${MY_VNC_USER}${tty_reset}"
    adduser "${MY_VNC_USER}"
    echo "${tty_green}请设置vnc密码${tty_reset}"
    vncpasswd
    # 把root账号生成的密码文件，复制到刚创建的用户目录
    mkdir -p "/home/${MY_VNC_USER}/.vnc/"
    /usr/bin/cp -rf  /root/.vnc/passwd "/home/${MY_VNC_USER}/.vnc/passwd"
    chown -R  "${MY_VNC_USER}" "/home/${MY_VNC_USER}/.vnc/"
    echo "${tty_green}正在配置vncserver@:1服务${tty_reset}"
    /usr/bin/cp -rf  /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:1.service
    sed  -i "s/<USER>/${MY_VNC_USER}/g" /etc/systemd/system/vncserver@:1.service
    echo "${tty_green}epel-release${tty_reset}"
    yum -y install epel-release
    echo "${tty_green}重新加载守护程序${tty_reset}"
    systemctl daemon-reload
    echo "${tty_green}正在安装Xfce${tty_reset}"
    yum groupinstall "Xfce" -y
    echo "${tty_green}正在安装cjkuni-ukai-fonts字体${tty_reset}"
    yum -y install cjkuni-ukai-fonts
    echo "${tty_green}正在卸载ibus输入法框架(忽略依赖)${tty_reset}"
    rpm -e --nodeps ibus
    echo "${tty_green}正在安装fcitx输入法框架${tty_reset}"
    #安装fcitx
    yum -y install fcitx fcitx-configtool
    #安装拼音输入法
    echo "${tty_green}正在安装拼音输入法${tty_reset}"
    yum -y install fcitx-pinyin
    #安装五笔输入法
    echo "${tty_green}正在安装五笔输入法${tty_reset}"
    yum -y install fcitx-table-chinese
    #初次加载服务，生成配置文件
    systemctl start vncserver@:1
    systemctl stop vncserver@:1
    #正在配置~/.vnc/xstartup
    echo "${tty_green}配置~/.vnc/xstartup${tty_reset}"
    echo "#!/bin/sh" > "/home/${MY_VNC_USER}/.vnc/xstartup"
    echo "unset SESSION_MANAGER" >> "/home/${MY_VNC_USER}/.vnc/xstartup"
    echo "unset DBUS_SESSION_BUS_ADDRESS" >> "/home/${MY_VNC_USER}/.vnc/xstartup"
    echo "export GTK_IM_MODULE=fcitx" >> "/home/${MY_VNC_USER}/.vnc/xstartup"
    echo "export QT_IM_MODULE=fcitx" >> "/home/${MY_VNC_USER}/.vnc/xstartup"
    echo "export XMODIFIERS=@im=fcitx" >> "/home/${MY_VNC_USER}/.vnc/xstartup"
    echo "startxfce4" >> "/home/${MY_VNC_USER}/.vnc/xstartup"
    echo "vncserver -kill $DISPLAY" >> "/home/${MY_VNC_USER}/.vnc/xstartup"
    #授权
    chmod +x "/home/${MY_VNC_USER}/.vnc/xstartup"
    chown -R  "${MY_VNC_USER}" "/home/${MY_VNC_USER}/.vnc/"
    #安装搜狗输入法
    echo "${tty_green}========安装搜狗输入法========${tty_reset}"
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

    echo "${tty_green}正在启动vnc服务，端口为5901${tty_reset}"
    systemctl start vncserver@:1
    echo "${tty_green}检查服务状态中${tty_reset}"
    systemctl status vncserver@:1

    echo "${tty_green}开放防火墙5901端口${tty_reset}"
    firewall-cmd --add-port=5901/tcp
    firewall-cmd --add-port=5901/tcp --permanent

    echo "${tty_cyan}----------------使用帮助----------------${tty_reset}"
    echo "${tty_cyan}VNC服务的端口是：5901${tty_reset}"
    echo "${tty_cyan}开启VNC服务：systemctl start vncserver@:1${tty_reset}"
    echo "${tty_cyan}开启VNC服务：systemctl stop vncserver@:1${tty_reset}"
    echo "${tty_cyan}开机启动VNC服务：systemctl enable vncserver@:1${tty_reset}"
    echo "${tty_cyan}禁用开机启动VNC服务：systemctl disable vncserver@:1${tty_reset}"

    echo "${tty_cyan}----------------使用帮助----------------${tty_reset}"

    echo "${tty_green}脚本执行完毕，祝您身体健康，万事如意!${tty_reset}"

;;
"2")
    echo "
    你选择了2、取消安装
    "
;;
esac
