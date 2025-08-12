import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets
import Quickshell

ContentPage {
    forceWidth: true

    ContentSection {
        title: "音频"

        ConfigSwitch {
            text: "听力保护"
            checked: Config.options.audio.protection.enable
            onCheckedChanged: {
                Config.options.audio.protection.enable = checked;
            }
            StyledToolTip {
                content: "防止音量突增并限制音量上限"
            }
        }
        ConfigRow {
            // uniform: true
            ConfigSpinBox {
                text: "最大允许增量"
                value: Config.options.audio.protection.maxAllowedIncrease
                from: 0
                to: 100
                stepSize: 2
                onValueChanged: {
                    Config.options.audio.protection.maxAllowedIncrease = value;
                }
            }
            ConfigSpinBox {
                text: "音量限制"
                value: Config.options.audio.protection.maxAllowed
                from: 0
                to: 100
                stepSize: 2
                onValueChanged: {
                    Config.options.audio.protection.maxAllowed = value;
                }
            }
        }
    }
    ContentSection {
        title: "人工智能"
        MaterialTextField {
            Layout.fillWidth: true
            placeholderText: "系统提示"
            text: Config.options.ai.systemPrompt
            wrapMode: TextEdit.Wrap
            onTextChanged: {
                Qt.callLater(() => {
                    Config.options.ai.systemPrompt = text;
                });
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
        title: "网络"
        MaterialTextField {
            Layout.fillWidth: true
            placeholderText: "用户代理（需要时使用）"
            text: Config.options.networking.userAgent
            wrapMode: TextEdit.Wrap
            onTextChanged: {
                Config.options.networking.userAgent = text;
            }
        }
    }

    ContentSection {
        title: "资源"
        ConfigSpinBox {
            text: "轮询间隔 (ms)"
            value: Config.options.resources.updateInterval
            from: 100
            to: 10000
            stepSize: 100
            onValueChanged: {
                Config.options.resources.updateInterval = value;
            }
        }
    }

    ContentSection {
        title: "搜索"

        ConfigSwitch {
            text: "使用基于莱文斯坦距离的算法而非模糊搜索"
            checked: Config.options.search.sloppy
            onCheckedChanged: {
                Config.options.search.sloppy = checked;
            }
            StyledToolTip {
                content: "如果你有很多拼写错误，效果可能会更好，\n但结果可能会很奇怪，并且可能不适用于首字母缩略词\n（例如，“GIMP” 可能不会给你 GIMP）"
            }
        }

        ContentSubsection {
            title: "前缀"
            ConfigRow {
                uniform: true

                MaterialTextField {
                    Layout.fillWidth: true
                    placeholderText: "动作"
                    text: Config.options.search.prefix.action
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        Config.options.search.prefix.action = text;
                    }
                }
                MaterialTextField {
                    Layout.fillWidth: true
                    placeholderText: "剪贴板"
                    text: Config.options.search.prefix.clipboard
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        Config.options.search.prefix.clipboard = text;
                    }
                }
                MaterialTextField {
                    Layout.fillWidth: true
                    placeholderText: "表情符号"
                    text: Config.options.search.prefix.emojis
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        Config.options.search.prefix.emojis = text;
                    }
                }
            }
        }
        ContentSubsection {
            title: "网页搜索"
            MaterialTextField {
                Layout.fillWidth: true
                placeholderText: "基本 URL"
                text: Config.options.search.engineBaseUrl
                wrapMode: TextEdit.Wrap
                onTextChanged: {
                    Config.options.search.engineBaseUrl = text;
                }
            }
        }
    }

    ContentSection {
        title: "时间"

        ContentSubsection {
            title: "格式"
            tooltip: ""

            ConfigSelectionArray {
                currentValue: Config.options.time.format
                configOptionName: "time.format"
                onSelected: newValue => {
                    if (newValue === "hh:mm") {
                        Quickshell.execDetached(["bash", "-c", `sed -i 's/\\TIME12\\b/TIME/' '${FileUtils.trimFileProtocol(Directories.config)}/hypr/hyprlock.conf'`]);
                    } else {
                        Quickshell.execDetached(["bash", "-c", `sed -i 's/\\TIME\\b/TIME12/' '${FileUtils.trimFileProtocol(Directories.config)}/hypr/hyprlock.conf'`]);
                    }

                    Config.options.time.format = newValue;
                    
                }
                options: [
                    {
                        displayName: "24小时",
                        value: "hh:mm"
                    },
                    {
                        displayName: "12小时 am/pm",
                        value: "h:mm ap"
                    },
                    {
                        displayName: "12小时 AM/PM",
                        value: "h:mm AP"
                    },
                ]
            }
        }
    }
}
