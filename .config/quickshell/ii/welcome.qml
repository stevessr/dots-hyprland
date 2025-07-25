//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

// Adjust this to make the app smaller or larger
//@ pragma Env QT_SCALE_FACTOR=1

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions

ApplicationWindow {
    id: root
    property string firstRunFilePath: FileUtils.trimFileProtocol(`${Directories.state}/user/first_run.txt`)
    property string firstRunFileContent: "This file is just here to confirm you've been greeted :>"
    property real contentPadding: 8
    property bool showNextTime: false
    visible: true
    onClosing: Qt.quit()
    title: "欢迎来到 illogical-impulse"

    Component.onCompleted: {
        MaterialThemeLoader.reapplyTheme()
    }

    minimumWidth: 600
    minimumHeight: 400
    width: 800
    height: 650
    color: Appearance.m3colors.m3background

    Process {
        id: konachanWallProc
        property string status: ""
        command: ["bash", "-c", Quickshell.shellPath("scripts/colors/random_konachan_wall.sh")]
        stdout: SplitParser {
            onRead: data => {
                console.log(`Konachan wall proc output: ${data}`);
                konachanWallProc.status = data.trim();
            }
        }
    }

    ColumnLayout {
        anchors {
            fill: parent
            margins: contentPadding
        }

        Item { // Titlebar
            visible: Config.options?.windows.showTitlebar
            Layout.fillWidth: true
            implicitHeight: Math.max(welcomeText.implicitHeight, windowControlsRow.implicitHeight)
            StyledText {
                id: welcomeText
                anchors {
                    left: Config.options.windows.centerTitle ? undefined : parent.left
                    horizontalCenter: Config.options.windows.centerTitle ? parent.horizontalCenter : undefined
                    verticalCenter: parent.verticalCenter
                    leftMargin: 12
                }
                color: Appearance.colors.colOnLayer0
                text: "哟，你好啊"
                font.pixelSize: Appearance.font.pixelSize.title
                font.family: Appearance.font.family.title
            }
            RowLayout { // Window controls row
                id: windowControlsRow
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                StyledText {
                    font.pixelSize: Appearance.font.pixelSize.smaller
                    text: "下次显示"
                }
                StyledSwitch {
                    id: showNextTimeSwitch
                    checked: root.showNextTime
                    scale: 0.6
                    Layout.alignment: Qt.AlignVCenter
                    onCheckedChanged: {
                        if (checked) {
                            Quickshell.execDetached(["rm", root.firstRunFilePath])
                        } else {
                            Quickshell.execDetached(["bash", "-c", `echo '${StringUtils.shellSingleQuoteEscape(root.firstRunFileContent)}' > '${StringUtils.shellSingleQuoteEscape(root.firstRunFilePath)}'`])
                        }
                    }
                }
                RippleButton {
                    buttonRadius: Appearance.rounding.full
                    implicitWidth: 35
                    implicitHeight: 35
                    onClicked: root.close()
                    contentItem: MaterialSymbol {
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        text: "close"
                        iconSize: 20
                    }
                }
            }
        }
        Rectangle { // Content container
            color: Appearance.m3colors.m3surfaceContainerLow
            radius: Appearance.rounding.windowRounding - root.contentPadding
            implicitHeight: contentColumn.implicitHeight
            implicitWidth: contentColumn.implicitWidth
            Layout.fillWidth: true
            Layout.fillHeight: true
            

            ContentPage {
                id: contentColumn
                anchors.fill: parent

                ContentSection {
                    title: "栏样式"

                    ConfigSelectionArray {
                        currentValue: Config.options.bar.cornerStyle
                        configOptionName: "bar.cornerStyle"
                        onSelected: (newValue) => {
                            Config.options.bar.cornerStyle = newValue; // Update local copy
                        }
                        options: [
                            { displayName: "拥抱", value: 0 },
                            { displayName: "浮动", value: 1 },
                            { displayName: "普通矩形", value: 2 }
                        ]
                    }
                }

                ContentSection {
                    title: "样式和壁纸"

                    ButtonGroup {
                        Layout.fillWidth: true
                        LightDarkPreferenceButton {
                            dark: false
                        }
                        LightDarkPreferenceButton {
                            dark: true
                        }
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        RippleButtonWithIcon {
                            id: rndWallBtn
                            Layout.alignment: Qt.AlignHCenter
                            buttonRadius: Appearance.rounding.small
                            materialIcon: "wallpaper"
                            mainText: konachanWallProc.running ? "请耐心等待..." : "随机：Konachan"
                            onClicked: {
                                console.log(konachanWallProc.command.join(" "))
                                konachanWallProc.running = true;
                            }
                            StyledToolTip {
                                content: "来自 Konachan 的随机 SFW 动漫壁纸\n图片保存在 ~/Pictures/Wallpapers"
                            }
                        }
                        RippleButtonWithIcon {
                            materialIcon: "wallpaper"
                            StyledToolTip {
                                content: "从您的系统中选择壁纸图片"
                            }
                            onClicked: {
                                Quickshell.execDetached([`${Directories.wallpaperSwitchScriptPath}`])
                            }
                            mainContentComponent: Component {
                                RowLayout {
                                    spacing: 10
                                    StyledText {
                                        font.pixelSize: Appearance.font.pixelSize.small
                                        text: "选择文件"
                                        color: Appearance.colors.colOnSecondaryContainer
                                    }
                                    RowLayout {
                                        spacing: 3
                                        KeyboardKey {
                                            key: "Ctrl"
                                        }
                                        KeyboardKey {
                                            key: "󰖳"
                                        }
                                        StyledText {
                                            Layout.alignment: Qt.AlignVCenter
                                            text: "+"
                                        }
                                        KeyboardKey {
                                            key: "T"
                                        }
                                    }
                                }
                            }
                        }
                    }

                    StyledText {
                        Layout.alignment: Qt.AlignHCenter
                        text: "稍后可随时在启动器中使用 /dark、/light、/img 进行更改"
                        font.pixelSize: Appearance.font.pixelSize.smaller
                        color: Appearance.colors.colSubtext
                    }
                }

                ContentSection {
                    title: "政策"

                    ConfigRow {
                        ColumnLayout { // Weeb policy
                            ContentSubsectionLabel {
                                text: "动漫爱好者"
                            }
                            ConfigSelectionArray {
                                currentValue: Config.options.policies.weeb
                                configOptionName: "policies.weeb"
                                onSelected: (newValue) => {
                                    Config.options.policies.weeb = newValue;
                                }
                                options: [
                                    { displayName: "否", value: 0 },
                                    { displayName: "是", value: 1 },
                                    { displayName: "壁橱", value: 2 }
                                ]
                            }
                        }

                        ColumnLayout { // AI policy
                            ContentSubsectionLabel {
                                text: "人工智能"
                            }
                            ConfigSelectionArray {
                                currentValue: Config.options.policies.ai
                                configOptionName: "policies.ai"
                                onSelected: (newValue) => {
                                    Config.options.policies.ai = newValue;
                                }
                                options: [
                                    { displayName: "否", value: 0 },
                                    { displayName: "是", value: 1 },
                                    { displayName: "仅本地", value: 2 }
                                ]
                            }
                        }
                    }
                }

                ContentSection {
                    title: "信息"

                    Flow {
                        Layout.fillWidth: true
                        spacing: 5

                        RippleButtonWithIcon {
                            materialIcon: "keyboard_alt"
                            onClicked: {
                                Quickshell.execDetached(["qs", "-p", Quickshell.shellPath(""), "ipc", "call", "cheatsheet", "toggle"])
                            }
                            mainContentComponent: Component {
                                RowLayout {
                                    spacing: 10
                                    StyledText {
                                        font.pixelSize: Appearance.font.pixelSize.small
                                        text: "快捷键"
                                        color: Appearance.colors.colOnSecondaryContainer
                                    }
                                    RowLayout {
                                        spacing: 3
                                        KeyboardKey {
                                            key: "󰖳"
                                        }
                                        StyledText {
                                            Layout.alignment: Qt.AlignVCenter
                                            text: "+"
                                        }
                                        KeyboardKey {
                                            key: "/"
                                        }
                                    }
                                }
                            }
                        }

                        RippleButtonWithIcon {
                            materialIcon: "help"
                            mainText: "使用情况"
                            onClicked: {
                                Qt.openUrlExternally("https://end-4.github.io/dots-hyprland-wiki/en/ii-qs/02usage/")
                            }
                        }
                        RippleButtonWithIcon {
                            materialIcon: "construction"
                            mainText: "配置"
                            onClicked: {
                                Qt.openUrlExternally("https://end-4.github.io/dots-hyprland-wiki/en/ii-qs/03config/")
                            }
                        }
                    }
                }

                ContentSection {
                    title: "无用的按钮"

                    Flow {
                        Layout.fillWidth: true
                        spacing: 5

                        RippleButtonWithIcon {
                            nerdIcon: "󰊤"
                            mainText: "GitHub"
                            onClicked: {
                                Qt.openUrlExternally("https://github.com/end-4/dots-hyprland")
                            }
                        }
                        RippleButtonWithIcon {
                            materialIcon: "favorite"
                            mainText: "Funny number"
                            onClicked: {
                                Qt.openUrlExternally("https://github.com/sponsors/end-4")
                            }
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }
    }
}
