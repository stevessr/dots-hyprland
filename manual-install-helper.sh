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
  printf "\n\e[31m[$0]: \!! 重要提示 \!! : 请确保环境变量 \e[0m \$ILLOGICAL_IMPULSE_VIRTUAL_ENV \e[31m 设置为正确的值 (默认为 \"~/.local/state/ags/.venv\")，否则 AGS 配置将无法工作。我们已经在 ~/.config/hypr/hyprland/env.conf 文件中提供了此项配置，但您需要确保它被包含在 hyprland.conf 中，并重启以使配置生效。\e[0m\n"
fi
