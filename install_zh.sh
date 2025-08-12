#!/usr/bin/env bash
cd "$(dirname "$0")"
export base="$(pwd)"
source ./scriptdata/environment-variables
source ./scriptdata/functions
source ./scriptdata/installers
source ./scriptdata/options

#####################################################################################
if ! command -v pacman >/dev/null 2>&1; then
  printf "\e[31m[$0]: 未找到 pacman，系统似乎不是 ArchLinux 或基于 Arch 的发行版。正在中止...\e[0m\n"
  exit 1
fi
prevent_sudo_or_root

startask () {
  printf "\e[34m[$0]: 您好！在我们开始之前：\n"
  printf '\n'
  printf '[新] illogical-impulse 现在由 Quickshell 驱动。如果您正在使用旧的 AGS 版本并希望保留它，请不要运行此脚本。\n'
  printf '      AGS 版本虽然使用较少的内存，但性能要差得多。如果您不需要（不一致的）翻译，建议使用 Quickshell 版本。\n'
  printf '      如果您仍然需要它，请在其分支中运行脚本：git checkout ii-ags && ./install.sh\n'
  printf '\n'
  printf '此脚本 1. 仅适用于 ArchLinux 和基于 Arch 的发行版。\n'
  printf '            2. 不处理系统级/硬件相关的东西，如 Nvidia 驱动程序\n'
  printf "\e[31m"

  printf "您想为 \"$XDG_CONFIG_HOME\" 和 \"$HOME/.local/\" 文件夹创建备份吗？\n[y/N]: "
  read -p " " backup_confirm
  case $backup_confirm in
    [yY][eE][sS]|[yY])
      backup_configs
      ;;
    *)
      echo "跳过备份..."
      ;;
  esac


  printf '\n'
  printf '您想在执行每个命令之前都进行确认吗？\n'
  printf '  y = 是的，在执行每个命令前询问我。（默认）\n'
  printf '  n = 不，直接自动执行它们。\n'
  printf '  a = 中止。\n'
  read -p "====> " p
  case $p in
    n) ask=false ;;
    a) exit 1 ;;
    *) ask=true ;;
  esac
}

case $ask in
  false)sleep 0 ;;
  *)startask ;;
esac

set -e
#####################################################################################
printf "\e[36m[$0]: 1. 获取软件包并设置用户组/服务\n\e[0m"

# Issue #363
case $SKIP_SYSUPDATE in
  true) sleep 0;;
  *) v sudo pacman -Syu;;
esac

remove_bashcomments_emptylines ${DEPLISTFILE} ./cache/dependencies_stripped.conf
readarray -t pkglist < ./cache/dependencies_stripped.conf

# 使用 yay。因为 paru 不支持 cleanbuild。
# 另请参阅 https://wiki.hyprland.org/FAQ/#how-do-i-update
if ! command -v yay >/dev/null 2>&1;then
  echo -e "\e[33m[$0]: 未找到 \"yay\"。\e[0m"
  showfun install-yay
  v install-yay
fi

# 从用户声明的 dependencies.conf 安装额外的软件包
if (( ${#pkglist[@]} != 0 )); then
	if $ask; then
		# 为数组 $pkglist 的每个元素执行
		for i in "${pkglist[@]}";do v yay -S --needed $i;done
	else
		# 在一行中为数组 $pkglist 的所有元素执行
		v yay -S --needed --noconfirm ${pkglist[*]}
	fi
fi

showfun handle-deprecated-dependencies
v handle-deprecated-dependencies

# https://github.com/end-4/dots-hyprland/issues/581
# yay -Bi 有点不可靠，所以我们进入相关目录并手动 source 和安装依赖
install-local-pkgbuild() {
	local location=$1
	local installflags=$2

	x pushd $location

	source ./PKGBUILD
	x yay -S $installflags --asdeps "${depends[@]}"
	x makepkg -Asi --noconfirm

	x popd
}

# 从元软件包安装核心依赖项
metapkgs=(./arch-packages/illogical-impulse-{audio,backlight,basic,fonts-themes,kde,portal,python,screencapture,toolkit,widgets})
metapkgs+=(./arch-packages/illogical-impulse-hyprland)
metapkgs+=(./arch-packages/illogical-impulse-microtex-git)
# metapkgs+=(./arch-packages/illogical-impulse-oneui4-icons-git)
[[ -f /usr/share/icons/Bibata-Modern-Classic/index.theme ]] || \
  metapkgs+=(./arch-packages/illogical-impulse-bibata-modern-classic-bin)

for i in "${metapkgs[@]}"; do
	metainstallflags="--needed"
	$ask && showfun install-local-pkgbuild || metainstallflags="$metainstallflags --noconfirm"
	v install-local-pkgbuild "$i" "$metainstallflags"
done

# 这些 python 包是使用 uv 安装的，而不是 pacman。
showfun install-python-packages
v install-python-packages

## 可选依赖项
if pacman -Qs ^plasma-browser-integration$ ;then SKIP_PLASMAINTG=true;fi
case $SKIP_PLASMAINTG in
  true) sleep 0;;
  *)
    if $ask;then
      echo -e "\e[33m[$0]: 注意: \"plasma-browser-integration\" 的大小约为 600 MiB。\e[0m"
      echo -e "\e[33m如果您希望在音乐控制小部件上显示 Firefox 中媒体的播放时间，则需要它。\e[0m"
      echo -e "\e[33m要安装吗？ [y/N]\e[0m"
      read -p "====> " p
    else
      p=y
    fi
    case $p in
      y) x sudo pacman -S --needed --noconfirm plasma-browser-integration ;;
      *) echo "好的，不安装"
    esac
    ;;
esac

v sudo usermod -aG video,i2c,input "$(whoami)"
v bash -c "echo i2c-dev | sudo tee /etc/modules-load.d/i2c-dev.conf"
v systemctl --user enable ydotool --now
v sudo systemctl enable bluetooth --now
v gsettings set org.gnome.desktop.interface font-name 'Rubik 11'
v gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
v kwriteconfig6 --file kdeglobals --group KDE --key widgetStyle Darkly


#####################################################################################
printf "\e[36m[$0]: 2. 复制 + 配置\e[0m\n"

# 以防某些文件夹不存在
v mkdir -p $XDG_BIN_HOME $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME

# `--delete' for rsync to make sure that
# original dotfiles and new ones in the SAME DIRECTORY
# (eg. in ~/.config/hypr) won't be mixed together

# MISC (For .config/* but not fish, not Hyprland)
case $SKIP_MISCCONF in
  true) sleep 0;;
  *)
    for i in $(find .config/ -mindepth 1 -maxdepth 1 ! -name 'fish' ! -name 'hypr' -exec basename {} \;); do
#      i=".config/$i"
      echo "[$0]: 找到目标: .config/$i"
      if [ -d ".config/$i" ];then v rsync -av --delete ".config/$i/" "$XDG_CONFIG_HOME/$i/"
      elif [ -f ".config/$i" ];then v rsync -av ".config/$i" "$XDG_CONFIG_HOME/$i"
      fi
    done
    ;;
esac

case $SKIP_FISH in
  true) sleep 0;;
  *)
    v rsync -av --delete .config/fish/ "$XDG_CONFIG_HOME"/fish/
    ;;
esac

# For Hyprland
case $SKIP_HYPRLAND in
  true) sleep 0;;
  *)
    v rsync -av --delete --exclude '/custom' --exclude '/hyprlock.conf' --exclude '/hypridle.conf' --exclude '/hyprland.conf' .config/hypr/ "$XDG_CONFIG_HOME"/hypr/
    t="$XDG_CONFIG_HOME/hypr/hyprland.conf"
    if [ -f $t ];then
      echo -e "\e[34m[$0]: \"$t\" 已存在。\e[0m"
      v mv $t $t.old
      v cp -f .config/hypr/hyprland.conf $t
      existed_hypr_conf_firstrun=y
    else
      echo -e "\e[33m[$0]: \"$t\" 尚不存在。\e[0m"
      v cp .config/hypr/hyprland.conf $t
      existed_hypr_conf=n
    fi
    t="$XDG_CONFIG_HOME/hypr/hypridle.conf"
    if [ -f $t ];then
      echo -e "\e[34m[$0]: \"$t\" 已存在。\e[0m"
      v cp -f .config/hypr/hypridle.conf $t.new
      existed_hypridle_conf=y
    else
      echo -e "\e[33m[$0]: \"$t\" 尚不存在。\e[0m"
      v cp .config/hypr/hypridle.conf $t
      existed_hypridle_conf=n
    fi
    t="$XDG_CONFIG_HOME/hypr/hyprlock.conf"
    if [ -f $t ];then
      echo -e "\e[34m[$0]: \"$t\" 已存在。\e[0m"
      v cp -f .config/hypr/hyprlock.conf $t.new
      existed_hyprlock_conf=y
    else
      echo -e "\e[33m[$0]: \"$t\" 尚不存在。\e[0m"
      v cp .config/hypr/hyprlock.conf $t
      existed_hyprlock_conf=n
    fi
    t="$XDG_CONFIG_HOME/hypr/custom"
    if [ -d $t ];then
      echo -e "\e[34m[$0]: \"$t\" 已存在，将不执行任何操作。\e[0m"
    else
      echo -e "\e[33m[$0]: \"$t\" 尚不存在。\e[0m"
      v rsync -av --delete .config/hypr/custom/ $t/
    fi
    ;;
esac


# some foldes (eg. .local/bin) should be processed separately to avoid `--delete' for rsync,
# since the files here come from different places, not only about one program.
# v rsync -av ".local/bin/" "$XDG_BIN_HOME" # No longer needed since scripts are no longer in ~/.local/bin
v rsync -av ".local/share/icons/" "${XDG_DATA_HOME:-$HOME/.local/share}"/icons/
v rsync -av ".local/share/konsole/" "${XDG_DATA_HOME:-$HOME/.local/share}"/konsole/

# Prevent hyprland from not fully loaded
sleep 1
try hyprctl reload

existed_zsh_conf=n
grep -q 'source ${XDG_CONFIG_HOME:-~/.config}/zshrc.d/dots-hyprland.zsh' ~/.zshrc && existed_zsh_conf=y

warn_files=()
warn_files_tests=()
warn_files_tests+=(/usr/local/lib/{GUtils-1.0.typelib,Gvc-1.0.typelib,libgutils.so,libgvc.so})
warn_files_tests+=(/usr/local/share/fonts/TTF/Rubik{,-Italic}'[wght]'.ttf)
warn_files_tests+=(/usr/local/share/licenses/ttf-rubik)
warn_files_tests+=(/usr/local/share/fonts/TTF/Gabarito-{Black,Bold,ExtraBold,Medium,Regular,SemiBold}.ttf)
warn_files_tests+=(/usr/local/share/licenses/ttf-gabarito)
warn_files_tests+=(/usr/local/share/icons/OneUI{,-dark,-light})
warn_files_tests+=(/usr/local/share/icons/Bibata-Modern-Classic)
warn_files_tests+=(/usr/local/bin/{LaTeX,res})
for i in ${warn_files_tests[@]}; do
  echo $i
  test -f $i && warn_files+=($i)
  test -d $i && warn_files+=($i)
done

#####################################################################################
printf "\e[36m[$0]: 完成。请查看 \"Import Manually\" 文件夹并获取您需要的任何内容。\e[0m\n"
printf "\n"
printf "\e[36m建议您查看\n"
printf "https://end-4.github.io/dots-hyprland-wiki/en/i-i/01setup/#post-installation \n"
printf "以获取有关启动 Hyprland 的提示。\e[0m\n"
printf "\n"
printf "\e[36m如果您已经在运行 Hyprland，\e[0m\n"
printf "\e[36m按 \e[30m\e[46m Ctrl+Super+T \e[0m\e[36m 选择壁纸\e[0m\n"
printf "\e[36m按 \e[30m\e[46m Super+/ \e[0m\e[36m 查看键位绑定列表\e[0m\n"
printf "\n"

case $existed_hypr_conf_firstrun in
  y) printf "\n\e[33m[$0]: 警告: \"$XDG_CONFIG_HOME/hypr/hyprland.conf\" 已存在。由于这似乎是您的首次运行，我们已将其替换为新的。 \e[0m\n"
     printf "\e[33m旧文件已重命名为 \"$XDG_CONFIG_HOME/hypr/hyprland.conf.old\"。\e[0m\n"
;;esac
case $existed_hypr_conf in
  y) printf "\n\e[33m[$0]: 警告: \"$XDG_CONFIG_HOME/hypr/hyprland.conf\" 已存在，我们没有覆盖它。 \e[0m\n"
     printf "\e[33m请使用 \"$XDG_CONFIG_HOME/hypr/hyprland.conf.new\" 作为正确格式的参考。\e[0m\n"
;;esac
case $existed_hypridle_conf in
  y) printf "\n\e[33m[$0]: 警告: \"$XDG_CONFIG_HOME/hypr/hypridle.conf\" 已存在，我们没有覆盖它。 \e[0m\n"
     printf "\e[33m请使用 \"$XDG_CONFIG_HOME/hypr/hypridle.conf.new\" 作为正确格式的参考。\e[0m\n"
;;esac
case $existed_hyprlock_conf in
  y) printf "\n\e[33m[$0]: 警告: \"$XDG_CONFIG_HOME/hypr/hyprlock.conf\" 已存在，我们没有覆盖它。 \e[0m\n"
     printf "\e[33m请使用 \"$XDG_CONFIG_HOME/hypr/hyprlock.conf.new\" 作为正确格式的参考。\e[0m\n"
;;esac

if [[ -z "${ILLOGICAL_IMPULSE_VIRTUAL_ENV}" ]]; then
  printf "\n\e[31m[$0]: \!! 重要 \!! : 请确保环境变量 \e[0m \$ILLOGICAL_IMPULSE_VIRTUAL_ENV \e[31m 设置为正确的值（默认为 \"~/.local/state/quickshell/.venv\"），否则 Quickshell 配置将无法工作。我们已经在 ~/.config/hypr/hyprland/env.conf 中提供了此配置，但您需要确保它包含在 hyprland.conf 中，并且需要重新启动才能应用它。\e[0m\n"
fi

if [[ ! -z "${warn_files[@]}" ]]; then
  printf "\n\e[31m[$0]: \!! 重要 \!! : 请尽快手动删除 \e[0m ${warn_files[*]} \e[31m，因为我们现在使用 AUR 包或本地 PKGBUILD 为 Arch（基于）Linux 发行版安装它们，它们将优先于我们的安装，或者至少占用更多空间。\e[0m\n"
fi