#!/usr/bin/env bash
# Check whether pkgs exist in AUR or repos of Arch.
# This is a workaround for https://github.com/end-4/dots-hyprland/discussions/204
# Do NOT abuse this since it consumes extra bandwidth from AUR server.

set -e
cd "$(dirname "$0")"
cd ..
export base="$(pwd)"
source ./scriptdata/functions
source ./scriptdata/installers

pkglistfile=$(mktemp)
pkglistfile_orig=./scriptdata/dependencies.conf
pkglistfile_orig_s=./cache/dependencies_stripped.conf
remove_bashcomments_emptylines $pkglistfile_orig $pkglistfile_orig_s

cat $pkglistfile_orig_s | sed "s_\ _\n_g" > $pkglistfile

echo "在 $pkglistfile_orig 中不存在的包如下所示。"
# Borrowed from https://bbs.archlinux.org/viewtopic.php?pid=1490795#p1490795
comm -23 <(sort -u $pkglistfile) <(sort -u <(wget -q -O - https://aur.archlinux.org/packages.gz | gunzip) <(pacman -Ssq))
echo "列表结束。如果没有显示任何内容，则所有包都存在。"
rm $pkglistfile
