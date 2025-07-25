import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets

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
                content: "防止音量突增并限制最大音量"
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
                text: "音量上限"
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
        title: "网络"
        MaterialTextField {
            Layout.fillWidth: true
            placeholderText: "用户代理（部分服务需要）"
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
            text: "轮询间隔 (毫秒)"
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
            text: "使用基于莱文斯坦距离的算法替代模糊搜索"
            checked: Config.options.search.sloppy
            onCheckedChanged: {
                Config.options.search.sloppy = checked;
            }
            StyledToolTip {
                content: "如果你经常打错字，这个算法可能更好用，\n但结果可能比较奇怪，而且可能不支持缩写\n（例如搜索 “GIMP” 可能不会出现那个绘图程序）"
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
            ConfigRow {
                description: "搜索引擎"
                uniform: true
                ComboBox {
                    id: searchEngineComboBox
                    Layout.fillWidth: true
                    model: Object.keys(Config.options.search.engines)
                    textRole: "name"
                    valueRole: "key"

                    delegate: ItemDelegate {
                        width: parent.width
                        contentItem: Text {
                            text: Config.options.search.engines[modelData].name
                            font: parent.font
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                        }
                        highlighted: searchEngineComboBox.currentIndex === index
                    }

                    Component.onCompleted: {
                        var keys = Object.keys(Config.options.search.engines);
                        var selectedIndex = keys.indexOf(Config.options.search.selectedEngine);
                        if (selectedIndex !== -1) {
                            searchEngineComboBox.currentIndex = selectedIndex;
                        }
                    }

                    onCurrentValueChanged: {
                        if (model.length > 0) {
                             Config.options.search.selectedEngine = currentValue
                        }
                    }

                    property var currentValue: model[currentIndex]
                }
            }
            MaterialTextField {
                Layout.fillWidth: true
                placeholderText: "基础 URL"
                text: Config.options.search.engines[Config.options.search.selectedEngine].url
                wrapMode: TextEdit.Wrap
                onTextChanged: {
                    Config.options.search.engines[Config.options.search.selectedEngine].url = text;
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
                    Config.options.time.format = newValue;
                }
                options: [
                    {
                        displayName: "24小时制",
                        value: "hh:mm"
                    },
                    {
                        displayName: "12小时制 (am/pm)",
                        value: "h:mm ap"
                    },
                    {
                        displayName: "12小时制 (AM/PM)",
                        value: "h:mm AP"
                    },
                ]
            }
        }
    }
}
