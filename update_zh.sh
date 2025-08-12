#!/usr/bin/env bash
#
# update.sh - 增强的 dotfiles 更新脚本
#
# 功能:
# - 从远程拉取最新提交
# - 如果 PKGBUILD 文件已更改，则重新构建软件包（用户选择）
# - 处理与用户选择的配置文件冲突
# - 尊重 .updateignore 文件中的排除项
#
set -uo pipefail

# === 配置 ===
FORCE_CHECK=false
CHECK_PACKAGES=false
REPO_DIR="$(cd "$(dirname "$0")" &>/dev/null && pwd)"
ARCH_PACKAGES_DIR="${REPO_DIR}/arch-packages"
UPDATE_IGNORE_FILE="${REPO_DIR}/.updateignore"
HOME_UPDATE_IGNORE_FILE="${HOME}/.updateignore"

# 要监视更改的目录
MONITOR_DIRS=(".config" ".local/bin")

# === 颜色代码 ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # 无颜色

# === 辅助函数 ===
log_info() {
  echo -e "${BLUE}[信息]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[成功]${NC} $1"
}

log_warning() {
  echo -e "${YELLOW}[警告]${NC} $1"
}

log_error() {
  echo -e "${RED}[错误]${NC} $1" >&2
}

log_header() {
  echo -e "\n${PURPLE}=== $1 ===${NC}"
}

die() {
  log_error "$1"
  exit 1
}

# 安全读取输入的函数，具有终端兼容性
safe_read() {
  local prompt="$1"
  local varname="$2"
  local default="${3:-}"

  # 简单方法：仅使用 read 和 /dev/tty 并处理错误
  local input_value=""

  # 显示提示并从终端读取
  echo -n "$prompt"
  if read input_value </dev/tty 2>/dev/null || read input_value 2>/dev/null; then
    eval "$varname='$input_value'"
    return 0
  else
    # 如果读取失败并且有默认值，则使用它
    if [[ -n "$default" ]]; then
      echo
      log_warning "使用默认值: $default"
      eval "$varname='$default'"
      return 0
    else
      echo
      log_error "无法读取输入"
      return 1
    fi
  fi
}

# 检查是否应忽略文件的函数
should_ignore() {
  local file_path="$1"
  local relative_path="${file_path#$HOME/}"

  # 同时获取相对于仓库的路径以进行仓库级别的忽略
  local repo_relative=""
  if [[ "$file_path" == "$REPO_DIR"* ]]; then
    repo_relative="${file_path#$REPO_DIR/}"
  fi

  # 检查仓库和主目录的忽略文件
  for ignore_file in "$UPDATE_IGNORE_FILE" "$HOME_UPDATE_IGNORE_FILE"; do
    if [[ -f "$ignore_file" ]]; then
      while IFS= read -r pattern || [[ -n "$pattern" ]]; do
        # 跳过空行和注释
        [[ -z "$pattern" || "$pattern" =~ ^[[:space:]]*# ]] && continue
        # 删除前导/尾随空格
        pattern=$(echo "$pattern" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        [[ -z "$pattern" ]] && continue

        # 处理不同的 gitignore 风格的模式
        local should_skip=false

        # 精确匹配
        if [[ "$relative_path" == "$pattern" ]] || [[ "$repo_relative" == "$pattern" ]]; then
          should_skip=true
        fi

        # 通配符模式（基本 glob 匹配）
        if [[ "$relative_path" == $pattern ]] || [[ "$repo_relative" == $pattern ]]; then
          should_skip=true
        fi

        # 目录模式（以 / 结尾）
        if [[ "$pattern" == */ ]]; then
          local dir_pattern="${pattern%/}"
          if [[ "$relative_path" == "$dir_pattern"/* ]] || [[ "$repo_relative" == "$dir_pattern"/* ]]; then
            should_skip=true
          fi
        fi

        # 以 / 开头的模式（从根目录开始）
        if [[ "$pattern" == /* ]]; then
          local root_pattern="${pattern#/}"
          if [[ "$relative_path" == "$root_pattern" ]] || [[ "$relative_path" == "$root_pattern"/* ]] ||
            [[ "$repo_relative" == "$root_pattern" ]] || [[ "$repo_relative" == "$root_pattern"/* ]]; then
            should_skip=true
          fi
        fi

        # 带通配符的模式
        if [[ "$pattern" == *"*"* ]]; then
          if [[ "$relative_path" == $pattern ]] || [[ "$repo_relative" == $pattern ]]; then
            should_skip=true
          fi
          # 同时检查是否有任何父目录匹配
          local temp_path="$relative_path"
          while [[ "$temp_path" == */* ]]; do
            temp_path="${temp_path%/*}"
            if [[ "$temp_path" == $pattern ]]; then
              should_skip=true
              break
            fi
          done
        fi

        # 简单子字符串匹配（用于向后兼容）
        if [[ ! "$should_skip" == true ]]; then
          if [[ "$file_path" == *"$pattern"* ]] || [[ "$relative_path" == *"$pattern"* ]]; then
            should_skip=true
          fi
        fi

        if [[ "$should_skip" == true ]]; then
          return 0
        fi
      done <"$ignore_file"
    fi
  done
  return 1
}

# 如果可能，显示带语法高亮的文件差异的函数
show_diff() {
  local file1="$1"
  local file2="$2"

  echo -e "\n${CYAN}显示差异:${NC}"
  echo -e "${CYAN}旧文件: $file1${NC}"
  echo -e "${CYAN}新文件: $file2${NC}"
  echo "----------------------------------------"

  if command -v diff &>/dev/null; then
    diff -u "$file1" "$file2" || true
  else
    echo "diff 命令不可用"
  fi
  echo "----------------------------------------"
}

# 处理文件冲突的函数
handle_file_conflict() {
  local repo_file="$1"
  local home_file="$2"
  local filename=$(basename "$home_file")
  local dirname=$(dirname "$home_file")

  echo -e "\n${YELLOW}检测到冲突:${NC} $home_file"
  echo "仓库版本与您的本地版本不同。"
  echo
  echo "选择一个操作:"
  echo "1) 用仓库版本替换本地文件"
  echo "2) 保持本地文件不变"
  echo "3) 将本地文件备份为 ${filename}.old，使用仓库版本"
  echo "4) 将仓库版本另存为 ${filename}.new，保留本地文件"
  echo "5) 显示差异并决定"
  echo "6) 跳过此文件"
  echo "7) 添加到忽略列表并跳过"
  echo

  while true; do
    if ! safe_read "输入您的选择 (1-7): " choice "6"; then
      echo
      log_warning "无法读取输入。正在跳过文件。"
      return
    fi

    case $choice in
    1)
      cp -p "$repo_file" "$home_file"
      log_success "已用仓库版本替换 $home_file"
      break
      ;;
    2)
      log_info "保留 $home_file 的本地版本"
      break
      ;;
    3)
      mv "$home_file" "${dirname}/${filename}.old"
      cp -p "$repo_file" "$home_file"
      log_success "已将本地文件备份到 ${filename}.old 并使用仓库版本更新"
      break
      ;;
    4)
      cp -p "$repo_file" "${dirname}/${filename}.new"
      log_success "已将仓库版本另存为 ${filename}.new，保留了本地文件"
      break
      ;;
    5)
      show_diff "$home_file" "$repo_file"
      echo
      echo "查看差异后，请选择:"
      echo "r) 用仓库版本替换"
      echo "k) 保留本地版本"
      echo "b) 备份本地文件并使用仓库版本"
      echo "n) 将仓库版本另存为 .new"
      echo "s) 跳过此文件"
      echo "i) 添加到忽略列表并跳过"

      if ! safe_read "输入您的选择 (r/k/b/n/s/i): " subchoice "s"; then
        echo
        log_warning "无法读取输入。正在跳过文件。"
        return
      fi

      case $subchoice in
      r)
        cp -p "$repo_file" "$home_file"
        log_success "已用仓库版本替换 $home_file"
        break
        ;;
      k)
        log_info "保留 $home_file 的本地版本"
        break
        ;;
      b)
        mv "$home_file" "${dirname}/${filename}.old"
        cp -p "$repo_file" "$home_file"
        log_success "已将本地文件备份到 ${filename}.old 并更新"
        break
        ;;
      n)
        cp -p "$repo_file" "${dirname}/${filename}.new"
        log_success "已将仓库版本另存为 ${filename}.new"
        break
        ;;
      s)
        log_info "正在跳过 $home_file"
        break
        ;;
      i)
        local relative_path_to_home="${home_file#$HOME/}"
        echo "$relative_path_to_home" >>"$HOME_UPDATE_IGNORE_FILE"
        log_success "已将 '$relative_path_to_home' 添加到 $HOME_UPDATE_IGNORE_FILE 并跳过。"
        break
        ;;
      *)
        echo "无效选择。请重试。"
        ;;
      esac
      ;;
    6)
      log_info "正在跳过 $home_file"
      break
      ;;
    7)
      local relative_path_to_home="${home_file#$HOME/}"
      echo "$relative_path_to_home" >>"$HOME_UPDATE_IGNORE_FILE"
      log_success "已将 '$relative_path_to_home' 添加到 $HOME_UPDATE_IGNORE_FILE 并跳过。"
      break
      ;;
    *)
      echo "无效选择。请输入 1-7。"
      ;;
    esac
  done
}

# 检查 PKGBUILD 是否已更改的函数
check_pkgbuild_changed() {
  local pkg_dir="$1"
  local pkgbuild_path="${pkg_dir}/PKGBUILD"

  [[ ! -f "$pkgbuild_path" ]] && return 1

  # 获取相对于仓库的路径
  local relative_path="${pkgbuild_path#$REPO_DIR/}"

  # 如果启用了强制检查，则始终返回 true
  if [[ "$FORCE_CHECK" == true ]]; then
    return 0
  fi

  # 检查文件在上次拉取中是否已更改
  if git diff --name-only HEAD@{1} HEAD 2>/dev/null | grep -q "^${relative_path}$"; then
    return 0
  fi

  return 1
}

# 列出可用软件包的函数
list_packages() {
  local available_packages=()
  local changed_packages=()

  if [[ ! -d "$ARCH_PACKAGES_DIR" ]]; then
    log_warning "未找到 arch-packages 目录"
    return 1
  fi

  for pkg_dir in "$ARCH_PACKAGES_DIR"/*/; do
    if [[ -f "${pkg_dir}/PKGBUILD" ]]; then
      local pkg_name=$(basename "$pkg_dir")
      available_packages+=("$pkg_name")

      if check_pkgbuild_changed "$pkg_dir"; then
        changed_packages+=("$pkg_name")
      fi
    fi
  done

  if [[ ${#available_packages[@]} -eq 0 ]]; then
    log_info "在 arch-packages 目录中未找到任何软件包"
    return 1
  fi

  echo -e "\n${CYAN}可用软件包:${NC}"
  for pkg in "${available_packages[@]}"; do
    if [[ " ${changed_packages[*]} " =~ " ${pkg} " ]]; then
      echo -e "  ${GREEN}● ${pkg}${NC} (PKGBUILD 已更改)"
    else
      echo -e "  ○ ${pkg}"
    fi
  done

  if [[ ${#changed_packages[@]} -gt 0 ]]; then
    echo -e "\n${YELLOW}PKGBUILD 已更改的软件包: ${changed_packages[*]}${NC}"
  fi

  return 0
}

# 构建所选软件包的函数
build_packages() {
  local build_mode="$1" # "changed", "all", or "select"
  local packages_to_build=()
  local rebuilt_packages=0

  case "$build_mode" in
  "changed")
    for pkg_dir in "$ARCH_PACKAGES_DIR"/*/; do
      if [[ -f "${pkg_dir}/PKGBUILD" ]]; then
        local pkg_name=$(basename "$pkg_dir")
        if check_pkgbuild_changed "$pkg_dir"; then
          packages_to_build+=("$pkg_name")
        fi
      fi
    done
    ;;
  "all")
    for pkg_dir in "$ARCH_PACKAGES_DIR"/*/; do
      if [[ -f "${pkg_dir}/PKGBUILD" ]]; then
        local pkg_name=$(basename "$pkg_dir")
        packages_to_build+=("$pkg_name")
      fi
    done
    ;;
  "select")
    echo -e "\n输入以空格分隔的软件包名称（或输入 'all' 表示所有软件包）:"
    if ! safe_read "要构建的软件包: " user_selection ""; then
      log_warning "无法读取输入。正在跳过软件包构建。"
      return
    fi

    if [[ "$user_selection" == "all" ]]; then
      for pkg_dir in "$ARCH_PACKAGES_DIR"/*/; do
        if [[ -f "${pkg_dir}/PKGBUILD" ]]; then
          local pkg_name=$(basename "$pkg_dir")
          packages_to_build+=("$pkg_name")
        fi
      done
    else
      read -ra packages_to_build <<<"$user_selection"
    fi
    ;;
  esac

  if [[ ${#packages_to_build[@]} -eq 0 ]]; then
    log_info "未选择要构建的软件包"
    return
  fi

  echo -e "\n${CYAN}要构建的软件包: ${packages_to_build[*]}${NC}"

  if ! safe_read "是否继续构建这些软件包? (Y/n): " confirm "Y"; then
    log_warning "无法读取输入。正在跳过软件包构建。"
    return
  fi

  if [[ "$confirm" =~ ^[Nn]$ ]]; then
    log_info "用户已取消软件包构建"
    return
  fi

  for pkg_name in "${packages_to_build[@]}"; do
    local pkg_dir="${ARCH_PACKAGES_DIR}/${pkg_name}"

    if [[ ! -d "$pkg_dir" || ! -f "${pkg_dir}/PKGBUILD" ]]; then
      log_error "未找到软件包或缺少 PKGBUILD: $pkg_name"
      continue
    fi

    log_info "正在构建软件包: $pkg_name"
    cd "$pkg_dir" || continue

    if makepkg -si --noconfirm; then
      log_success "成功构建并安装了 $pkg_name"
      ((rebuilt_packages++))
    else
      log_error "构建软件包 $pkg_name 失败"
    fi

    cd "$REPO_DIR" || die "返回仓库目录失败"
  done

  if [[ $rebuilt_packages -eq 0 ]]; then
    log_warning "没有成功构建的软件包"
  else
    log_success "成功重新构建了 $rebuilt_packages 个软件包"
  fi
}

# 获取自上次拉取以来已更改的文件列表，或在强制检查时获取所有文件的函数
get_changed_files() {
  local dir_path="$1"

  if [[ "$FORCE_CHECK" == true ]]; then
    # 返回目录中的所有文件
    find "$dir_path" -type f -print0 2>/dev/null
  else
    # 获取上次拉取中已更改的文件
    local changed_files=()
    while IFS= read -r file; do
      local full_path="${REPO_DIR}/${file}"
      # 检查文件是否在正在处理的目录中
      if [[ "$full_path" == "$dir_path"/* ]] && [[ -f "$full_path" ]]; then
        printf '%s\0' "$full_path"
      fi
    done < <(git diff --name-only HEAD@{1} HEAD 2>/dev/null || true)

    # 如果通过 git 没有文件更改，但 force_check 为 false，则仍检查所有文件
    # 这处理了没有新提交但文件可能不同的情况
    if ! git diff --quiet HEAD@{1} HEAD 2>/dev/null; then
      : # 通过 git diff 找到了文件
    else
      # 未检测到 git 更改，仍检查所有文件以查找本地差异
      find "$dir_path" -type f -print0 2>/dev/null
    fi
  fi
}

# 检查是否有新提交的函数
has_new_commits() {
  # 检查 HEAD@{1} 是否存在（表示有先前的提交）
  if git rev-parse --verify HEAD@{1} &>/dev/null; then
    # 检查 HEAD 和 HEAD@{1} 是否不同
    [[ "$(git rev-parse HEAD)" != "$(git rev-parse HEAD@{1})" ]]
  else
    # 没有先前的提交引用，假设有提交
    return 0
  fi
}

# 主脚本从这里开始
log_header "Dotfiles 更新脚本"

check=true

# 解析命令行参数
while [[ $# -gt 0 ]]; do
  case $1 in
  -f | --force)
    FORCE_CHECK=true
    log_info "强制检查模式已启用 - 将检查所有文件，无论 git 是否有更改"
    shift
    ;;
  -p | --packages)
    CHECK_PACKAGES=true
    log_info "软件包检查已启用"
    shift
    ;;
  -h | --help)
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  -f, --force      强制检查所有文件，即使没有新提交"
    echo "  -p, --packages   启用软件包检查和构建"
    echo "  -h, --help       显示此帮助消息"
    echo ""
    echo "此脚本通过以下方式更新您的 dotfiles:"
    echo "  1. 从 git 远程拉取最新更改"
    echo "  2. 可选地重新构建软件包（如果使用 -p 标志）"
    echo "  3. 同步配置文件"
    echo "  4. 更新脚本权限"
    echo ""
    echo "软件包模式（当使用 -p 时）:"
    echo "  - 如果没有 PKGBUILD 更改：询问您是否仍要检查软件包"
    echo "  - 如果 PKGBUILD 已更改：提供构建已更改软件包的选项"
    echo "  - 交互式选择要构建的软件包"
    exit 0
    ;;
  --skip-notice)
    log_warning "跳过关于脚本未经测试的通知"
    check=false
    shift
    ;;
  *)
    log_error "未知选项: $1"
    echo "使用 --help 获取用法信息"
    exit 1
    ;;
  esac
done

if [[ "$check" == true ]]; then
  log_warning "此脚本未经完全测试，可能会导致问题！"
  safe_read "继续使用即表示您自担风险 (y/N): " response "N"

  if [[ ! "$response" =~ ^[Yy]$ ]]; then
    log_error "用户中止了更新"
    exit 1
  fi
fi

# 检查我们是否在 git 仓库中
cd "$REPO_DIR" || die "切换到仓库目录失败"

if git rev-parse --is-inside-work-tree &>/dev/null; then
  log_info "正在 git 仓库中运行: $(git rev-parse --show-toplevel)"
else
  log_error "不在 git 仓库中。请从您的 dotfiles 仓库运行此脚本。"
  exit 1
fi

# 第 1 步：拉取最新提交
log_header "正在拉取最新更改"

# 检查当前分支
current_branch=$(git branch --show-current)
if [[ -z "$current_branch" ]]; then
  log_warning "处于分离 HEAD 状态。正在检出 main/master 分支..."
  if git show-ref --verify --quiet refs/heads/main; then
    git checkout main
    current_branch="main"
  elif git show-ref --verify --quiet refs/heads/master; then
    git checkout master
    current_branch="master"
  else
    die "找不到 main 或 master 分支"
  fi
fi

log_info "当前分支: $current_branch"

# 检查未提交的更改
if ! git diff --quiet || ! git diff --cached --quiet; then
  log_warning "您有未提交的更改:"
  git status --short
  echo

  if ! safe_read "您想继续吗？这将储藏您的更改。(y/N): " response "N"; then
    echo
    log_error "无法读取输入。正在中止。"
    exit 1
  fi

  if [[ ! "$response" =~ ^[Yy]$ ]]; then
    die "用户已中止"
  fi
  git stash push -m "更新前自动储藏 $(date)"
  log_info "更改已储藏"
fi

# 检查远程是否存在
if git remote get-url origin &>/dev/null; then
  # 拉取更改
  log_info "正在从 origin/$current_branch 拉取更改..."
  if git pull; then
    log_success "成功拉取最新更改"
  else
    log_warning "从远程拉取更改失败。将继续使用本地仓库..."
    log_info "您可能需要稍后手动解决冲突。"
  fi
else
  log_warning "未配置远程 'origin'。正在跳过拉取操作。"
  log_info "这似乎是一个仅限本地的仓库。"
fi

# 第 2 步：处理软件包构建（仅当请求时）
rebuilt_packages=0

if [[ "$CHECK_PACKAGES" == true ]]; then
  log_header "软件包管理"

  if [[ ! -d "$ARCH_PACKAGES_DIR" ]]; then
    log_warning "未找到 arch-packages 目录。正在跳过软件包管理。"
  else
    # 检查是否有任何 PKGBUILD 已更改
    changed_pkgbuilds=()
    for pkg_dir in "$ARCH_PACKAGES_DIR"/*/; do
      if [[ -f "${pkg_dir}/PKGBUILD" ]]; then
        local pkg_name=$(basename "$pkg_dir")
        if check_pkgbuild_changed "$pkg_dir"; then
          changed_pkgbuilds+=("$pkg_name")
        fi
      fi
    done

    if [[ ${#changed_pkgbuilds[@]} -gt 0 ]]; then
      log_info "发现 ${#changed_pkgbuilds[@]} 个软件包的 PKGBUILD 已更改: ${changed_pkgbuilds[*]}"
      echo
      echo "软件包构建选项:"
      echo "1) 仅构建 PKGBUILD 已更改的软件包"
      echo "2) 列出所有软件包并选择要构建的"
      echo "3) 构建所有软件包"
      echo "4) 跳过软件包构建"
      echo

      if safe_read "选择一个选项 (1-4): " pkg_choice "1"; then
        case $pkg_choice in
        1)
          build_packages "changed"
          ;;
        2)
          if list_packages; then
            build_packages "select"
          fi
          ;;
        3)
          build_packages "all"
          ;;
        4 | *)
          log_info "正在跳过软件包构建"
          ;;
        esac
      else
        log_warning "无法读取输入。正在跳过软件包构建。"
      fi
    else
      log_info "自上次更新以来，没有 PKGBUILD 发生更改。"
      echo
      if safe_read "您是否仍要检查并构建软件包？(y/N): " check_anyway "N"; then
        if [[ "$check_anyway" =~ ^[Yy]$ ]]; then
          if list_packages; then
            echo
            echo "软件包构建选项:"
            echo "1) 选择要构建的特定软件包"
            echo "2) 构建所有软件包"
            echo "3) 跳过软件包构建"

            if safe_read "选择一个选项 (1-3): " build_choice "3"; then
              case $build_choice in
              1)
                build_packages "select"
                ;;
              2)
                build_packages "all"
                ;;
              3 | *)
                log_info "正在跳过软件包构建"
                ;;
              esac
            else
              log_info "正在跳过软件包构建"
            fi
          fi
        else
          log_info "正在跳过软件包管理"
        fi
      else
        log_info "正在跳过软件包管理"
      fi
    fi
  fi
else
  log_header "软件包管理"
  log_info "软件包检查已禁用。使用 -p 或 --packages 标志启用软件包管理。"

  # 如果存在已更改的 PKGBUILD，仍显示提示
  if [[ -d "$ARCH_PACKAGES_DIR" ]]; then
    changed_count=0
    for pkg_dir in "$ARCH_PACKAGES_DIR"/*/; do
      if [[ -f "${pkg_dir}/PKGBUILD" ]] && check_pkgbuild_changed "$pkg_dir"; then
        ((changed_count++))
      fi
    done

    if [[ $changed_count -gt 0 ]]; then
      log_warning "注意: $changed_count 个软件包的 PKGBUILD 已更改。使用 -p 标志管理软件包。"
    fi
  fi
fi

# 第 3 步：更新配置文件
log_header "正在更新配置文件"

# 检查我们是否应该处理文件
process_files=false
if [[ "$FORCE_CHECK" == true ]]; then
  process_files=true
  log_info "强制模式：正在检查所有配置文件"
elif has_new_commits; then
  process_files=true
  log_info "检测到新提交：正在检查已更改的配置文件"
else
  log_info "未找到新提交：正在检查本地文件差异"
  process_files=true # 即使没有提交也始终检查差异
fi

if [[ "$process_files" == true ]]; then
  files_processed=0
  files_updated=0
  files_created=0

  for dir_name in "${MONITOR_DIRS[@]}"; do
    repo_dir_path="${REPO_DIR}/${dir_name}"
    home_dir_path="${HOME}/${dir_name}"

    if [[ ! -d "$repo_dir_path" ]]; then
      log_warning "未找到仓库目录: $repo_dir_path"
      continue
    fi

    log_info "正在处理目录: $dir_name"

    # 如果主目录不存在，则创建它
    mkdir -p "$home_dir_path"

    # 获取要处理的文件（基于模式的已更改文件或所有文件）
    while IFS= read -r -d '' repo_file; do
      # 计算相对路径和相应的主文件路径
      rel_path="${repo_file#$repo_dir_path/}"
      home_file="${home_dir_path}/${rel_path}"

      # 检查是否应忽略文件
      if should_ignore "$home_file"; then
        continue
      fi

      ((files_processed++))

      # 如果需要，创建目录结构
      mkdir -p "$(dirname "$home_file")"

      if [[ -f "$home_file" ]]; then
        # 文件存在，检查是否不同
        if ! cmp -s "$repo_file" "$home_file"; then
          log_info "在以下文件中发现差异: $rel_path"
          handle_file_conflict "$repo_file" "$home_file"
          ((files_updated++))
        fi
      else
        # 新文件，复制它
        cp -p "$repo_file" "$home_file"
        log_success "已创建新文件: $home_file"
        ((files_created++))
      fi
    done < <(get_changed_files "$repo_dir_path")
  done

  # 显示处理摘要
  echo
  log_info "文件处理摘要:"
  log_info "- 已处理文件: $files_processed"
  log_info "- 有冲突的文件: $files_updated"
  log_info "- 已创建的新文件: $files_created"
else
  log_info "正在跳过文件更新（未检测到更改且未处于强制模式）"
fi

# 第 4 步：更新脚本权限
log_header "正在更新脚本权限"

if [[ -d "${REPO_DIR}/scriptdata" ]]; then
  find "${REPO_DIR}/scriptdata" -type f -name "*.sh" -exec chmod +x {} \;
  find "${REPO_DIR}/scriptdata" -type f -executable -exec chmod +x {} \;
  log_success "已更新脚本权限"
fi

# 确保本地 bin 脚本是可执行的
if [[ -d "${HOME}/.local/bin" ]]; then
  find "${HOME}/.local/bin" -type f -exec chmod +x {} \; 2>/dev/null || true
  log_success "已更新 ~/.local/bin 脚本权限"
fi

log_header "更新完成"
log_success "Dotfiles 更新成功完成！"

# 显示摘要
echo
echo -e "${CYAN}摘要:${NC}"
echo "- 仓库: $(git log -1 --pretty=format:'%h - %s (%cr)')"
echo "- 分支: $current_branch"
echo "- 模式: $([ "$FORCE_CHECK" == true ] && echo "强制检查" || echo "正常")"
echo "- 软件包检查: $([ "$CHECK_PACKAGES" == true ] && echo "已启用" || echo "已禁用")"

if [[ $rebuilt_packages -gt 0 ]]; then
  echo "- 重新构建的软件包: $rebuilt_packages"
fi

if [[ "$process_files" == true ]]; then
  echo "- 已处理文件: $files_processed"
  echo "- 已更新/冲突的文件: $files_updated"
  echo "- 已创建的新文件: $files_created"
fi

echo "- 配置目录: ${MONITOR_DIRS[*]}"

# 提醒有关忽略文件并显示示例
if [[ ! -f "$HOME_UPDATE_IGNORE_FILE" && ! -f "$UPDATE_IGNORE_FILE" ]]; then
  echo
  log_info "提示: 创建忽略文件以从更新中排除文件:"
  echo "  - 仓库忽略: ${REPO_DIR}/.updateignore"
  echo "  - 用户忽略: ~/.updateignore"
  echo
  echo "示例模式:"
  echo "  *.log                 # 忽略所有 .log 文件"
  echo "  .config/personal/     # 忽略整个目录"
  echo "  secret-config.conf    # 忽略特定文件"
  echo "  /temp-file            # 仅从根目录忽略"
  echo "  *secret*              # 忽略包含 'secret' 的文件"
fi

echo