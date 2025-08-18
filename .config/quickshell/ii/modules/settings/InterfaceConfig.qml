import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets

ContentPage {
    forceWidth: true
    ContentSection {
        title: "策略"

        ConfigRow {
            ColumnLayout {
                // Weeb policy
                ContentSubsectionLabel {
                    text: "动漫"
                }
                ConfigSelectionArray {
                    currentValue: Config.options.policies.weeb
                    configOptionName: "policies.weeb"
                    onSelected: newValue => {
                        Config.options.policies.weeb = newValue;
                    }
                    options: [
                        {
                            displayName: "否",
                            value: 0
                        },
                        {
                            displayName: "是",
                            value: 1
                        },
                        {
                            displayName: "隐藏",
                            value: 2
                        }
                    ]
                }
            }

            ColumnLayout {
                // AI policy
                ContentSubsectionLabel {
                    text: "人工智能"
                }
                ConfigSelectionArray {
                    currentValue: Config.options.policies.ai
                    configOptionName: "policies.ai"
                    onSelected: newValue => {
                        Config.options.policies.ai = newValue;
                    }
                    options: [
                        {
                            displayName: "否",
                            value: 0
                        },
                        {
                            displayName: "是",
                            value: 1
                        },
                        {
                            displayName: "仅本���",
                            value: 2
                        }
                    ]
                }
            }
        }
    }

    ContentSection {
        title: "状态栏"

        ConfigRow {
            ContentSubsection {
                title: "Corner style"

                ConfigSelectionArray {
                    currentValue: Config.options.bar.cornerStyle
                    configOptionName: "bar.cornerStyle"
                    onSelected: newValue => {
                        Config.options.bar.cornerStyle = newValue; // Update local copy
                    }
                    options: [
                        {
                            displayName: "贴合",
                            value: 0
                        },
                        {
                            displayName: "悬浮",
                            value: 1
                        },
                        {
                            displayName: "直角矩形",
                            value: 2
                        }
                    ]
                }
            }

            ContentSubsection {
                title: "Bar layout"
                ConfigSelectionArray {
                    currentValue: Config.options.bar.vertical
                    configOptionName: "bar.vertical"
                    onSelected: newValue => {
                        Config.options.bar.vertical = newValue;
                    }
                    options: [
                        {
                            displayName: Translation.tr("Horizontal"),
                            value: false
                        },
                        {
                            displayName: Translation.tr("Vertical"),
                            value: true
                        },
                    ]
                }
            }
        }

        ContentSubsection {
            title: "整体外观"
            ConfigRow {
                uniform: true
                ConfigSwitch {
                    text: "自动隐藏"
                    checked: Config.options.bar.autoHide.enable
                    onCheckedChanged: {
                        Config.options.bar.autoHide.enable = checked;
                    }
                }
                ConfigSwitch {
                    text: "置于底部"
                    checked: Config.options.bar.bottom
                    onCheckedChanged: {
                        Config.options.bar.bottom = checked;
                    }
                }
            }
            ConfigRow {
                uniform: true
                ConfigSwitch {
                    text: '无边���'
                    checked: Config.options.bar.borderless
                    onCheckedChanged: {
                        Config.options.bar.borderless = checked;
                    }
                }
                ConfigSwitch {
                    text: '显示背景'
                    checked: Config.options.bar.showBackground
                    onCheckedChanged: {
                        Config.options.bar.showBackground = checked;
                    }
                    StyledToolTip {
                        content: "注意：关闭可能会影响可读性"
                    }
                }
            }
        }

        ContentSubsection {
            title: "按钮"
            ConfigRow {
                uniform: true
                ConfigSwitch {
                    text: "截屏"
                    checked: Config.options.bar.utilButtons.showScreenSnip
                    onCheckedChanged: {
                        Config.options.bar.utilButtons.showScreenSnip = checked;
                    }
                }
                ConfigSwitch {
                    text: "颜色选择器"
                    checked: Config.options.bar.utilButtons.showColorPicker
                    onCheckedChanged: {
                        Config.options.bar.utilButtons.showColorPicker = checked;
                    }
                }
            }
            ConfigRow {
                uniform: true
                ConfigSwitch {
                    text: "麦克风切换"
                    checked: Config.options.bar.utilButtons.showMicToggle
                    onCheckedChanged: {
                        Config.options.bar.utilButtons.showMicToggle = checked;
                    }
                }
                ConfigSwitch {
                    text: "键盘切换"
                    checked: Config.options.bar.utilButtons.showKeyboardToggle
                    onCheckedChanged: {
                        Config.options.bar.utilButtons.showKeyboardToggle = checked;
                    }
                }
            }
            ConfigRow {
                uniform: true
                ConfigSwitch {
                    text: "深色/浅色切换"
                    checked: Config.options.bar.utilButtons.showDarkModeToggle
                    onCheckedChanged: {
                        Config.options.bar.utilButtons.showDarkModeToggle = checked;
                    }
                }
                ConfigSwitch {
                    text: "性能配置文件切换"
                    checked: Config.options.bar.utilButtons.showPerformanceProfileToggle
                    onCheckedChanged: {
                        Config.options.bar.utilButtons.showPerformanceProfileToggle = checked;
                    }
                }
            }
        }

        ContentSubsection {
            title: "工作区"
            tooltip: "提示：隐藏图标并始终显示数字以获得\n经典的 illogical-impulse 体验"

            ConfigRow {
                uniform: true
                ConfigSwitch {
                    text: '显示应用图标'
                    checked: Config.options.bar.workspaces.showAppIcons
                    onCheckedChanged: {
                        Config.options.bar.workspaces.showAppIcons = checked;
                    }
                }
                ConfigSwitch {
                    text: '着色应用图标'
                    checked: Config.options.bar.workspaces.monochromeIcons
                    onCheckedChanged: {
                        Config.options.bar.workspaces.monochromeIcons = checked;
                    }
                }
            }
            ConfigSwitch {
                text: '始终显示数字'
                checked: Config.options.bar.workspaces.alwaysShowNumbers
                onCheckedChanged: {
                    Config.options.bar.workspaces.alwaysShowNumbers = checked;
                }
            }
            ConfigSpinBox {
                text: "显示的工作区"
                value: Config.options.bar.workspaces.shown
                from: 1
                to: 30
                stepSize: 1
                onValueChanged: {
                    Config.options.bar.workspaces.shown = value;
                }
            }
            ConfigSpinBox {
                text: "按下 Super 键时数字显示延迟 (ms)"
                value: Config.options.bar.workspaces.showNumberDelay
                from: 0
                to: 1000
                stepSize: 50
                onValueChanged: {
                    Config.options.bar.workspaces.showNumberDelay = value;
                }
            }
        }

        ContentSubsection {
            title: "托盘"
            
            ConfigSwitch {
                text: '着色图标'
                checked: Config.options.bar.tray.monochromeIcons
                onCheckedChanged: {
                    Config.options.bar.tray.monochromeIcons = checked;
                }
            }
        }

        ContentSubsection {
            title: "天气"
            ConfigSwitch {
                text: "启用"
                checked: Config.options.bar.weather.enable
                onCheckedChanged: {
                    Config.options.bar.weather.enable = checked;
                }
            }
        }
    }

    ContentSection {
        title: "电池"

        ConfigRow {
            uniform: true
            ConfigSpinBox {
                text: "低电量警告"
                value: Config.options.battery.low
                from: 0
                to: 100
                stepSize: 5
                onValueChanged: {
                    Config.options.battery.low = value;
                }
            }
            ConfigSpinBox {
                text: "严重低电量警告"
                value: Config.options.battery.critical
                from: 0
                to: 100
                stepSize: 5
                onValueChanged: {
                    Config.options.battery.critical = value;
                }
            }
        }
        ConfigRow {
            uniform: true
            ConfigSwitch {
                text: "自动挂起"
                checked: Config.options.battery.automaticSuspend
                onCheckedChanged: {
                    Config.options.battery.automaticSuspend = checked;
                }
                StyledToolTip {
                    content: "电池电量低时自动挂起系统"
                }
            }
            ConfigSpinBox {
                text: "挂起电量"
                value: Config.options.battery.suspend
                from: 0
                to: 100
                stepSize: 5
                onValueChanged: {
                    Config.options.battery.suspend = value;
                }
            }
        }
    }

    ContentSection {
        title: "Dock"

        ConfigSwitch {
            text: "启用"
            checked: Config.options.dock.enable
            onCheckedChanged: {
                Config.options.dock.enable = checked;
            }
        }

        ConfigRow {
            uniform: true
            ConfigSwitch {
                text: "悬停显示"
                checked: Config.options.dock.hoverToReveal
                onCheckedChanged: {
                    Config.options.dock.hoverToReveal = checked;
                }
            }
            ConfigSwitch {
                text: "启动��固定"
                checked: Config.options.dock.pinnedOnStartup
                onCheckedChanged: {
                    Config.options.dock.pinnedOnStartup = checked;
                }
            }
        }
        ConfigSwitch {
            text: "着色应用图标"
            checked: Config.options.dock.monochromeIcons
            onCheckedChanged: {
                Config.options.dock.monochromeIcons = checked;
            }
        }
    }

    ContentSection {
        title: "侧边��"
        ConfigSwitch {
            text: '保持右侧边栏加载'
            checked: Config.options.sidebar.keepRightSidebarLoaded
            onCheckedChanged: {
                Config.options.sidebar.keepRightSidebarLoaded = checked;
            }
            StyledToolTip {
                content: "启用后，右侧边栏的���容将保持加载状态，以减少打开时的延迟，\n代价是���约 15MB 的持续 RAM 使用量。延迟的重要性取决于您的系统性能。\n使用像 linux-cachyos 这样的自定义内核可能会有所帮助"
            }
        }
    }

    ContentSection {
        title: "屏幕显示"
        ConfigSpinBox {
            text: "超时 (ms)"
            value: Config.options.osd.timeout
            from: 100
            to: 3000
            stepSize: 100
            onValueChanged: {
                Config.options.osd.timeout = value;
            }
        }
    }

    ContentSection {
        title: "概览"
        ConfigSwitch {
            text: "启用"
            checked: Config.options.overview.enable
            onCheckedChanged: {
                Config.options.overview.enable = checked;
            }
        }
        ConfigSpinBox {
            text: "缩放 (%)"
            value: Config.options.overview.scale * 100
            from: 1
            to: 100
            stepSize: 1
            onValueChanged: {
                Config.options.overview.scale = value / 100;
            }
        }
        ConfigRow {
            uniform: true
            ConfigSpinBox {
                text: "行"
                value: Config.options.overview.rows
                from: 1
                to: 20
                stepSize: 1
                onValueChanged: {
                    Config.options.overview.rows = value;
                }
            }
            ConfigSpinBox {
                text: "列"
                value: Config.options.overview.columns
                from: 1
                to: 20
                stepSize: 1
                onValueChanged: {
                    Config.options.overview.columns = value;
                }
            }
        }
    }

    ContentSection {
        title: "截图工��"

        ConfigSwitch {
            text: '显示可能感兴趣的区域'
            checked: Config.options.screenshotTool.showContentRegions
            onCheckedChanged: {
                Config.options.screenshotTool.showContentRegions = checked;
            }
            StyledToolTip {
                content: "这些区域可能是图像或屏幕上包含某些内容的��分。\n可能不总是准确。\n这是通过本���运行的图像处理算法完成的，没有使用人工智能。"
            }
        }        
    }
}
