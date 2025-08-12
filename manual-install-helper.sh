#!/usr/bin/env bash
#
# 此脚本用于为非 Arch 用户安装/更新一些“软件包”。
#

cd "$(dirname "$0")"
export base="$(pwd)"
source ./scriptdata/environment-variables
source ./scriptdata/functions
source ./scriptdata/installers
prevent_sudo_or_root

if command -v pacman >/dev/null 2>&1;then printf "\e[31m[$0]: 检测到 pacman，系统似乎是 ArchLinux 或基于 Arch 的发行版。正在中止...\e[0m\n";exit 1;fi
v install-Rubik
v install-Gabarito
v install-OneUI
v install-bibata
v install-MicroTeX
v install-uv
v install-python-packages

if [[ -z "${ILLOGICAL_IMPULSE_VIRTUAL_ENV}" ]]; then
  printf "\n\e[31m[$0]: \!! 重要 \!! : 请确保环境变量 \e[0m \$ILLOGICAL_IMPULSE_VIRTUAL_ENV \e[31m 已设置为正确的值 (默认为 \"~/.local/state/ags/.venv\")，否则 AGS 配置将无法工作。我们已经在 ~/.config/hypr/hyprland/env.conf 中提供了此配置，但您需要确保它已包含在 hyprland.conf 中，并且需要重新启动才能应用它。\e[0m\n"
fi
