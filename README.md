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

## 一键更新nvim配置文件
更新上面脚本搭建的环境的配置文件，不需要root权限，普通用户执行即可。
```bash
sh -c "$(curl -fsSL https://gitee.com/lxyoucan/tools/raw/master/centos7/nvim/nvimIDEUpdate.sh)"
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
## node.js 14安装小助手
欢迎使用，node.js 14安装小助手！ By:ITKEY 日期：2021-11-30
本脚本用于自动下载安装node.js，因为一些发行版本的软件管理器无法安装新版node.js。
比如：银河麒麟桌面操作系统V10 (SP1)
```bash
bash -c "$(curl -fsSL https://gitee.com/lxyoucan/tools/raw/master/common/node14install.sh)"
```

## 下载Linux版本frp
```bash
sh -c "$(curl -fsSL https://gitee.com/lxyoucan/tools/raw/master/common/frp/frpdown.sh)"
```

## neovim 自动配置文件更新小助手(全平台支持) 
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

```bash
bash -c "$(curl -fsSL https://gitee.com/lxyoucan/tools/raw/master/common/nvimIDE.sh)"
```
## Termux安装node.js开发必备软件
```bash
bash -c "$(curl -fsSL https://gitee.com/lxyoucan/tools/raw/master/termux/runtime.sh)"
```

