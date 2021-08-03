# CentOS7专用脚本
因为我平时接触的大部分机器都是CentOS7,这里的脚本都是针对CentOS7开发的。虽然个人比较喜欢新的软件，喜欢archlinux这样的发行版本，但是服务器上使用CentOS的还是要更多一些的。
## Xfce桌面一键VNC脚本
- Xfce桌面
- fcitx输入法框架
- 搜狗输入法
- 五笔输入法

```bash
sh -c "$(curl -fsSL https://gitee.com/lxyoucan/tools/raw/master/centos7/XfceVnc.sh)"
```
注意：
1. **脚本需要root权限执行**
## Openbox一键VNC脚本
- Openbox
- fcitx输入法框架
- 搜狗输入法
- 五笔输入法

```bash
sh -c "$(curl -fsSL https://gitee.com/lxyoucan/tools/raw/master/centos7/OpenboxVnc.sh)"
```

注意：
1. **脚本需要root权限执行**

### 说明
脚本绿色无后门，可以重复执行。目前只有安装脚本，如果需要卸载，请参考安装脚本。手动执行yum remove .....。

客户端连接示例：
随便找一个vnc客户端，连接地址： ip(或者域名)+:5901

```bash
172.16.184.5:5901
```
![172.16.184.5:5901](https://img-blog.csdnimg.cn/d698b45ec622433980912f3b0ad0cad5.png)

## 一键搭建nvim + react开发环境
- python3
- node.js v14
- nvim-coc等等相关vim插件
- ranger
- oh my zsh自动配置
```bash
sh -c "$(curl -fsSL https://gitee.com/lxyoucan/tools/raw/master/centos7/nvim/nvimIDE.sh)"
```

## oh my zsh 一键安装
```bash
sh -c "$(curl -fsSL https://gitee.com/lxyoucan/tools/raw/master/centos7/ohmyzsh.sh)"
```
注意：
1. **脚本需要root权限执行**

## 编译安装tmux新版本
原汁原味，无配置文件修改
```bash
sh -c "$(curl -fsSL https://gitee.com/lxyoucan/tools/raw/master/centos7/tmux/tmuxinstall.sh)"
```
注意：
1. **脚本需要root权限执行**

## 编译安装tmux新版本+ITKEY配置
编译安装+ITKEY配置文件
```bash
sh -c "$(curl -fsSL https://gitee.com/lxyoucan/tools/raw/master/centos7/tmux/tmuxinstall-itkey.sh)"
```
注意：
1. **脚本需要root权限执行**
# 通用脚本
理论上支持大部分linux发行版本或者macOS
## 国内加速oh my zsh一键安装脚本
官方原版本，只是把github库换成了CSDN的镜像。国内访问比较快。
```bash
sh -c "$(curl -fsSL https://gitee.com/lxyoucan/tools/raw/master/common/ohmyzshinstall.sh)"
```

## 国内加速oh my zsh ITKEY个性化配置版
集成如下插件
- 语法高亮插件
- 自动补全插件

仅下载相关文件（~/.oh-my-zsh与oh-my-zsh配置文件），不检测先决条件，比如是否安装了zsh。

```bash
sh -c "$(curl -fsSL https://gitee.com/lxyoucan/tools/raw/master/common/ohmyzsh_itkey.sh)"
```

## 下载Linux版本frp
```bash
sh -c "$(curl -fsSL https://gitee.com/lxyoucan/tools/raw/master/common/frp/frpdown.sh)"
```

