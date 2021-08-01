![在这里插入图片描述](https://img-blog.csdnimg.cn/45d65a9b6ec44a5cb0838ff8de2a48c3.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2x4eW91Y2Fu,size_16,color_FFFFFF,t_70)


最近在研究舒适，小巧，好用的图形界面远程控制。输入法这块卡了我很久时间，经过一周的努力，查资料无数，终于打造出一套可以令自己满意的远程方案了。
我的工作中接触的远程Linux服务系统90%以上是CentOS7操作系统。对于本人来说，大部分工作可以通过ssh来实现。很低的概率需要使用图形界面远程操作。但是对于命令行不熟悉的同事，如果有个好用的图形界面的远程控制会方便不少，比如：远程调试只有内网可以访问的数据库，或者web界面。

我的要求如下：
- 小巧安装方便。
- 不影响系统的稳定性。
- 好用，对于新手易上手。

桌面这块我尝试了openbox、Gnome3、Xfce综合测试完以后。
- openbox小巧好用，但是对于新手不友好。最主要的是因为默认无法显示透明窗体，导致搜狗输入法会出现大黑边。虽然大黑边能通过其他软件解决，但是编译代码比较久。还需要从github下载源码，网络环境不友好。所以我放弃了这种方案。
- Gnome3虽然界面比较友好，但是相比openbox太臃肿了，安装完1G+，这样会导致安装时间也比较长，硬盘空间占用较多。对于硬件配置低的服务器不友好。个人感觉界面操作上也没有其他两者流畅。不用它的最主要原因是：在vnc的环境中gnome与fcitx输入法不兼容，部分软件无法切到输入法。本机图形界面环境中fcitx输入法使用正常。
- Xfce 是我最后测试的方案。虽然一开始并没有打算用它，但是用了以后，我很满意。正好弥补了上面两种方案的缺点。介于上面两者之间的一种选择。

**最终选择的是Xfce桌面+fcitx+搜狗输入法的组合。**
为了分享和新手安装方便我特意做成了一个一键安装脚本分享给大家。

# 什么是VNC
VNC（Virtual Network Computing），为一种使用RFB协议的屏幕画面分享及远程操作软件。此软件借由网络，可发送键盘与鼠标的动作及即时的屏幕画面。

VNC与操作系统无关，因此可跨平台使用，例如可用Windows连线到某Linux的电脑，反之亦同。甚至在没有安装客户端程序的电脑中，只要有支持JAVA的浏览器，也可使用。


# 视频演示
[https://www.bilibili.com/video/BV1a341167SW?share_source=copy_web](https://www.bilibili.com/video/BV1a341167SW?share_source=copy_web)

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

# Gnome一键VNC脚本
因为Gnome在vnc中使用fcitx输入法，部分软件无法正常输入中文的，所以Gnome使用自带的ibus输入法就行。
Gnome 使用ibus输入法很简单，参考
[https://blog.csdn.net/lxyoucan/article/details/113179208](https://blog.csdn.net/lxyoucan/article/details/113179208)
手动安装即可。

如果有需要一键安装脚本，评论留言我会考虑开发一下。



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

# 实现原理
如果你是有shell脚本基础，直接看脚本就好了，关键地方都有注释。

为了这个脚本的实现，我做的笔记如下可供参考。

- 《CentOS7安装搜狗输入法》
  [https://blog.csdn.net/lxyoucan/article/details/119119392](https://blog.csdn.net/lxyoucan/article/details/119119392)

- 《CentOS7+VNC+Openbox+Fcitx》
  [https://blog.csdn.net/lxyoucan/article/details/119081236](https://blog.csdn.net/lxyoucan/article/details/119081236)

- 《2021CentOS7系统Gnome3桌面使用Fcitx》
  [https://blog.csdn.net/lxyoucan/article/details/119103475](https://blog.csdn.net/lxyoucan/article/details/119103475)
- 《archlinux配置Xfce+fcitx5中文输入法》
  [https://blog.csdn.net/lxyoucan/article/details/116897679](https://blog.csdn.net/lxyoucan/article/details/116897679)
-  《archlinux安装配置vnc+openbox》
   [https://blog.csdn.net/lxyoucan/article/details/116780297](https://blog.csdn.net/lxyoucan/article/details/116780297)
