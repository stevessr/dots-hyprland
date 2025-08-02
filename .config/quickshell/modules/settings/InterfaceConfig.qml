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
                    text: "二次元"
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
                            displayName: "仅本地",
                            value: 2
                        }
                    ]
                }
            }
        }
    }

    ContentSection {
        title: "状态栏"

        ConfigSelectionArray {
            currentValue: Config.options.bar.cornerStyle
            configOptionName: "bar.cornerStyle"
            onSelected: newValue => {
                Config.options.bar.cornerStyle = newValue;
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
                    displayName: "矩形",
                    value: 2
                }
            ]
        }

        ContentSubsection {
            title: "外观"
            ConfigRow {
                uniform: true
                ConfigSwitch {
                    text: "无边框"
                    checked: Config.options.bar.borderless
                    onCheckedChanged: {
                        Config.options.bar.borderless = checked;
                    }
                }
                ConfigSwitch {
                    text: "显示背景"
                    checked: Config.options.bar.showBackground
                    onCheckedChanged: {
                        Config.options.bar.showBackground = checked;
                    }
                    StyledToolTip {
                        content: "注意：关闭背景可能影响可读性"
                    }
                }
            }
        }

        ContentSubsection {
            title: "按钮"
            ConfigRow {
                uniform: true
                ConfigSwitch {
                    text: "截图"
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
                    text: "麦克风开关"
                    checked: Config.options.bar.utilButtons.showMicToggle
                    onCheckedChanged: {
                        Config.options.bar.utilButtons.showMicToggle = checked;
                    }
                }
                ConfigSwitch {
                    text: "键盘开关"
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
                    text: Translation.tr("Performance Profile toggle")
                    checked: Config.options.bar.utilButtons.showPerformanceProfileToggle
                    onCheckedChanged: {
                        Config.options.bar.utilButtons.showPerformanceProfileToggle = checked;
                    }
                }
            }
        }

        ContentSubsection {
            title: "工作区"
            tooltip: "提示：隐藏图标并始终显示数字，以获得经典的 illogical-impulse 体验"

            ConfigRow {
                uniform: true
                ConfigSwitch {
                    text: "显示应用图标"
                    checked: Config.options.bar.workspaces.showAppIcons
                    onCheckedChanged: {
                        Config.options.bar.workspaces.showAppIcons = checked;
                    }
                }
                ConfigSwitch {
                    text: "始终显示数字"
                    checked: Config.options.bar.workspaces.alwaysShowNumbers
                    onCheckedChanged: {
                        Config.options.bar.workspaces.alwaysShowNumbers = checked;
                    }
                }
            }
            ConfigSpinBox {
                text: "显示的工作区数量"
                value: Config.options.bar.workspaces.shown
                from: 1
                to: 30
                stepSize: 1
                onValueChanged: {
                    Config.options.bar.workspaces.shown = value;
                }
            }
            ConfigSpinBox {
                text: "按下 Super 键后显示数字的延迟 (毫秒)"
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
                text: "自动休眠"
                checked: Config.options.battery.automaticSuspend
                onCheckedChanged: {
                    Config.options.battery.automaticSuspend = checked;
                }
                StyledToolTip {
                    content: "电量低时自动休眠"
                }
            }
            ConfigSpinBox {
                text: "休眠电量"
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
        title: "程序坞"

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
                text: "启动时固定"
                checked: Config.options.dock.pinnedOnStartup
                onCheckedChanged: {
                    Config.options.dock.pinnedOnStartup = checked;
                }
            }
        }
    }

    ContentSection {
        title: "屏幕显示"
        ConfigSpinBox {
            text: "超时 (毫秒)"
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
        title: "截图工具"

        ConfigSwitch {
            text: "显示可能感兴趣的区域"
            checked: Config.options.screenshotTool.showContentRegions
            onCheckedChanged: {
                Config.options.screenshotTool.showContentRegions = checked;
            }
            StyledToolTip {
                content: "这些区域可能是图像或屏幕上具有某种包含关系的区域。\n可能不总是准确。\n这是通过本地运行的图像处理算法完成的，没有使用人工智能。"
            }
        }        
    }
}
