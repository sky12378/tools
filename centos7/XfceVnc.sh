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
# 原本这个变量是由用户输入的，为了减少用户输入操作，暂时写死了
MY_DOWN_NUM=1
echo "${tty_reset}"
case $MY_DOWN_NUM in
"1")

    echo "${tty_universal} vnc端口可以为2位以内的纯数字，如：1 2 3 4 等等。这个号最终决定vnc的端口，算法5900+数字。假如你输入1则最终端口就是5901${tty_reset} "
    echo "${tty_reset}"
      echo "${tty_blue}请输入vnc端口（纯数字,示例 1）: "
      read -r MY_VNC_PORT
    echo "${tty_reset}"
    if ! [[ "$MY_VNC_PORT" =~ ^[0-9]+$ ]]
      then
        echo "您输入的不是数字，程序退出"
        exit
    fi
    echo "${tty_green}您输入的是：${MY_VNC_PORT}对应的VNC端口：$((5900 + MY_VNC_PORT ))${tty_reset}"

    echo "${tty_blue}请输入用于连接vnc的用户名: "
      read -r MY_VNC_USER
    echo "${tty_reset}"
    echo "${tty_green}您输入的用户名是:${MY_VNC_USER}${tty_reset}"

    echo "${tty_green}正在安装tigervnc-server${tty_reset}"
    yum -y install tigervnc-server
    echo "${tty_green}正在创建用户${MY_VNC_USER},如果用户已经存在可忽略${tty_reset}"
    adduser "${MY_VNC_USER}"
    echo "${tty_green}请设置vnc密码${tty_reset}"
    vncpasswd
    # 把root账号生成的密码文件，复制到刚创建的用户目录
    mkdir -p "/home/${MY_VNC_USER}/.vnc/"
    /usr/bin/cp -rf  /root/.vnc/passwd "/home/${MY_VNC_USER}/.vnc/passwd"
    chown -R  "${MY_VNC_USER}" "/home/${MY_VNC_USER}/.vnc/"
    echo "${tty_green}正在配置vncserver@:${MY_VNC_PORT}服务${tty_reset}"
    /usr/bin/cp -rf  /lib/systemd/system/vncserver@.service "/etc/systemd/system/vncserver@:${MY_VNC_PORT}.service"
    sed  -i "s/<USER>/${MY_VNC_USER}/g" "/etc/systemd/system/vncserver@:${MY_VNC_PORT}.service"
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
    systemctl start "vncserver@:${MY_VNC_PORT}"
    systemctl stop "vncserver@:${MY_VNC_PORT}"
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
    #添加QT依赖
    yum -y install fcitx-qt5 fcitx-configtool

    #检查安装包是否已经存在，如果存在则不重新下载安装包了(优化多次运行脚本的体验)
    if [ ! -f "./sogoupinyin-2.2.0.0108-2.x86_64.rpm" ]; then
      yum -y install wget
      yum -y install alien
      echo "${tty_green}正在下载搜狗输入法${tty_reset}"
      wget http://cdn2.ime.sogou.com/dl/index/1524572264/sogoupinyin_2.2.0.0108_amd64.deb
      echo "${tty_green}正在转换安装包${tty_reset}"
      alien -r --scripts sogoupinyin_2.2.0.0108_amd64.deb
    fi
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

    echo "${tty_green}正在启动vnc服务，端口为$((5900 + MY_VNC_PORT ))${tty_reset}"
    systemctl start "vncserver@:${MY_VNC_PORT}"
    echo "${tty_green}检查服务状态中${tty_reset}"
    systemctl status "vncserver@:${MY_VNC_PORT}"

    echo "${tty_green}开放防火墙$((5900 + MY_VNC_PORT ))端口${tty_reset}"
    firewall-cmd "--add-port=$((5900 + MY_VNC_PORT ))/tcp"
    firewall-cmd "--add-port=$((5900 + MY_VNC_PORT ))/tcp" --permanent

     echo "${tty_cyan}----------------使用帮助----------------${tty_reset}"
    echo "${tty_cyan}VNC服务的端口是：$((5900 + MY_VNC_PORT ))${tty_reset}"
    IP_ADDR=$(ip route get 1 | awk '{print $NF;exit}')
    echo "${tty_cyan}VNC客户端连接地址（仅供参考）：${IP_ADDR}:$((5900 + MY_VNC_PORT ))${tty_reset}"
    echo "${tty_cyan}开启VNC服务：systemctl start vncserver@:${MY_VNC_PORT}${tty_reset}"
    echo "${tty_cyan}开启VNC服务：systemctl stop vncserver@:${MY_VNC_PORT}${tty_reset}"
    echo "${tty_cyan}开机启动VNC服务：systemctl enable vncserver@:${MY_VNC_PORT}${tty_reset}"
    echo "${tty_cyan}禁用开机启动VNC服务：systemctl disable vncserver@:${MY_VNC_PORT}${tty_reset}"
    echo "${tty_cyan}
修改分辨率：配置文件/home/${MY_VNC_USER}/.vnc/config
geometry=1920x1080
设置完成后，重启服务生效。
systemctl restart vncserver@:${MY_VNC_PORT}
    ${tty_reset}"

    echo "${tty_cyan}----------------使用帮助----------------${tty_reset}"
    echo "${tty_green}脚本执行完毕，祝您身体健康，万事如意!${tty_reset}"

;;
"2")
    echo "
    你选择了2、取消安装
    "
;;
esac
