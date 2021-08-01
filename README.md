
# Xfce桌面一键VNC脚本
- Xfce桌面
- fcitx输入法框架
- 搜狗输入法
- 五笔输入法


使用root用户执行以下命令，即可简单快捷的完成以上软件的安装。
```bash
sh -c "$(curl -fsSL https://gitee.com/lxyoucan/tools/raw/master/centos7/XfceVnc.sh)"
```

注意：
1. **脚本需要root权限执行**
2. **脚本仅支持CentOS7**

# Openbox一键VNC脚本
- Openbox
- fcitx输入法框架
- 搜狗输入法
- 五笔输入法


使用root用户执行以下命令，即可简单快捷的完成以上软件的安装。
```bash
sh -c "$(curl -fsSL https://gitee.com/lxyoucan/tools/raw/master/centos7/OpenboxVnc.sh)"
```

注意：
1. **脚本需要root权限执行**
2. **脚本仅支持CentOS7**

## 说明
脚本绿色无后门，可以重复执行。目前只有安装脚本，如果需要卸载，请参考安装脚本。手动执行yum remove .....。

- VNC服务的端口是：5901
- 开启VNC服务：`systemctl start vncserver@:1`
- 开启VNC服务：`systemctl stop vncserver@:1`
- 开机启动VNC服务：`systemctl enable vncserver@:1`
- 禁用开机启动VNC服务：`systemctl disable vncserver@:1`

客户端连接示例：
随便找一个vnc客户端，连接地址： ip(或者域名)+:5901

```bash
172.16.184.5:5901
```
![172.16.184.5:5901](https://img-blog.csdnimg.cn/d698b45ec622433980912f3b0ad0cad5.png)


# Gnome一键VNC脚本
因为Gnome在vnc中使用fcitx输入法，部分软件无法正常输入中文的，所以Gnome使用自带的ibus输入法就行。
Gnome 使用ibus输入法很简单，参考
[https://blog.csdn.net/lxyoucan/article/details/113179208](https://blog.csdn.net/lxyoucan/article/details/113179208)
手动安装即可。

如果有需要一键安装脚本，评论留言我会考虑开发一下。

# 一键搭建nvim + react开发环境
- python3
- node.js v14
- nvim-coc等等相关vim插件
- ranger
```bash
sh -c "$(curl -fsSL https://gitee.com/lxyoucan/tools/raw/master/centos7/nvim/nvimIDE.sh)"
```
# 国内加速oh my zsh一键安装脚本
官方原版本，只是把github库换成了CSDN的镜像。国内访问比较快。
```bash
sh -c "$(curl -fsSL https://gitee.com/lxyoucan/tools/raw/master/common/ohmyzshinstall.sh)"
```

# 国内加速oh my zsh ITKEY个性化配置版
集成如下插件
- 语法高亮插件
- 自动补全插件

仅下载相关文件（~/.oh-my-zsh与oh-my-zsh配置文件），不检测先决条件，比如是否安装了zsh。

```bash
sh -c "$(curl -fsSL https://gitee.com/lxyoucan/tools/raw/master/common/ohmyzsh_itkey.sh)"
```

