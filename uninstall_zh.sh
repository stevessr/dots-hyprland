#!/usr/bin/env bash
cd "$(dirname "$0")"
source ./scriptdata/environment-variables
source ./scriptdata/functions
prevent_sudo_or_root

function v() {
  echo -e "[$0]: \e[32m正在执行:\e[0m"
  echo -e "\e[32m$@\e[0m"
  "$@"
}

printf '你好！\n'
printf '本脚本 1. 将卸载 [end-4/dots-hyprland > illogical-impulse] 的 dotfiles\n'
printf '            2. 将尝试恢复通过 install.sh 安装的*几乎所有内容*，因此破坏性较强\n'
printf '            3. 尚未经过测试，请自行承担风险。\n'
printf '            4. 将显示其运行的所有命令。\n'
printf '按 Ctrl+C 退出。按 Enter 继续。\n'
read -r
set -e
##############################################################################################################################

# 撤销步骤 3：删除已复制的配置和本地文件夹
printf '\e[36m正在删除已复制的配置和本地文件夹...\n\e[97m'

for i in ags fish fontconfig foot fuzzel hypr mpv wlogout "starship.toml" rubyshot
  do v rm -rf "$XDG_CONFIG_HOME/$i"
done
for i in "glib-2.0/schemas/com.github.GradienceTeam.Gradience.Devel.gschema.xml" "gradience"
  do v rm -rf "$XDG_DATA_HOME/$i"
done
v rm -rf "$XDG_BIN_HOME/fuzzel-emoji"
v rm -rf "$XDG_CACHE_HOME/ags"
v sudo rm -rf "$XDG_STATE_HOME/ags"

##############################################################################################################################

# 撤销步骤 2：卸载 AGS - 目前已禁用，请检查问题
# echo '正在卸载 AGS...'
# sudo meson uninstall -C ~/ags/build
# rm -rf ~/ags

##############################################################################################################################

# 撤销步骤 1：从 video、i2c 和 input 组中删除已添加的用户并删除 yay 软件包
printf '\e[36m正在从 video、i2c 和 input 组中删除用户并移除软件包...\n\e[97m'
user=$(whoami)
v sudo gpasswd -d "$user" video
v sudo gpasswd -d "$user" i2c
v sudo gpasswd -d "$user" input
v sudo rm /etc/modules-load.d/i2c-dev.conf

##############################################################################################################################
read -p "您想卸载这些 dotfiles 使用的软件包吗？\n按 Ctrl+C 退出，或按 Enter 继续"

# 删除已安装的 yay 软件包和依赖项
v yay -Rns illogical-impulse-{agsv1,audio,backlight,basic,bibata-modern-classic-bin,fonts-themes,gnome,gtk,hyprland,microtex-git,oneui4-icons-git,
portal,python,screencapture,widgets} plasma-browser-integration

printf '\e[36m卸载完成。\n\e[97m'