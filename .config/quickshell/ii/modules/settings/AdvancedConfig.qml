import QtQuick
import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets

ContentPage {
    forceWidth: true

    ContentSection {
        title: "颜色生成"

        ConfigRow {
            uniform: true
            ConfigSwitch {
                text: "Shell 和实用程序"
                checked: Config.options.appearance.wallpaperTheming.enableAppsAndShell
                onCheckedChanged: {
                    Config.options.appearance.wallpaperTheming.enableAppsAndShell = checked;
                }
            }
            ConfigSwitch {
                text: "Qt 应用"
                checked: Config.options.appearance.wallpaperTheming.enableQtApps
                onCheckedChanged: {
                    Config.options.appearance.wallpaperTheming.enableQtApps = checked;
                }
                StyledToolTip {
                    content: "Shell 和实用程序主题也必须启用"
                }
            }
            ConfigSwitch {
                text: "终端"
                checked: Config.options.appearance.wallpaperTheming.enableTerminal
                onCheckedChanged: {
                    Config.options.appearance.wallpaperTheming.enableTerminal = checked;
                }
                StyledToolTip {
                    content: "Shell 和实用程序主题也必须启用"
                }
            }

        }
    }
}
