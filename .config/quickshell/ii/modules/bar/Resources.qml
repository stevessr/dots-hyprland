import qs.modules.common
import qs.services
import QtQuick
import QtQuick.Layouts

MouseArea {
    id: root
    property bool borderless: Config.options.bar.borderless
    property bool alwaysShowAllResources: false
    implicitWidth: rowLayout.implicitWidth + rowLayout.anchors.leftMargin + rowLayout.anchors.rightMargin
    implicitHeight: Appearance.sizes.barHeight
    hoverEnabled: true

    RowLayout {
        id: rowLayout

        spacing: 0
        anchors.fill: parent
        anchors.leftMargin: 4
        anchors.rightMargin: 4

        Resource {
            iconName: "memory"
            percentage: ResourceUsage.memoryUsedPercentage

            tooltipHeaderIcon: "memory"
            tooltipHeaderText: "内存使用情况"
            tooltipData: [
                { icon: "clock_loader_60", label: "已用：", value: formatKB(ResourceUsage.memoryUsed) },
                { icon: "check_circle", label: "可用：", value: formatKB(ResourceUsage.memoryFree) },
                { icon: "empty_dashboard", label: "总计：", value: formatKB(ResourceUsage.memoryTotal) },
            ]
        }

        Resource {
            iconName: "swap_horiz"
            percentage: ResourceUsage.swapUsedPercentage
            shown: (Config.options.bar.resources.alwaysShowSwap && percentage > 0) || 
                (MprisController.activePlayer?.trackTitle == null) ||
                root.alwaysShowAllResources
            Layout.leftMargin: shown ? 4 : 0

            tooltipHeaderIcon: "swap_horiz"
            tooltipHeaderText: "交换空间使用情况"
            tooltipData: ResourceUsage.swapTotal > 0 ? [
                { icon: "clock_loader_60", label: "已用：", value: formatKB(ResourceUsage.swapUsed) },
                { icon: "check_circle", label: "可用：", value: formatKB(ResourceUsage.swapFree) },
                { icon: "empty_dashboard", label: "总计：", value: formatKB(ResourceUsage.swapTotal) },
            ] : [
                { icon: "swap_horiz", label: "交换：", value: "未配置" }
            ]
        }

        Resource {
            iconName: "planner_review"
            percentage: ResourceUsage.cpuUsage
            shown: Config.options.bar.resources.alwaysShowCpu || 
                !(MprisController.activePlayer?.trackTitle?.length > 0) ||
                root.alwaysShowAllResources
            Layout.leftMargin: shown ? 4 : 0

            tooltipHeaderIcon: "settings_slow_motion"
            tooltipHeaderText: "CPU 使用情况"
            tooltipData: [
                { icon: "bolt", label: "负��：", value: (ResourceUsage.cpuUsage > 0.8 ?
                    "高" :
                    ResourceUsage.cpuUsage > 0.4 ? "中" : "低")
                    + ` (${Math.round(ResourceUsage.cpuUsage * 100)}%)`
                }
            ]
        }

    }

    ResourcesPopup {
        hoverTarget: root
    }
}
