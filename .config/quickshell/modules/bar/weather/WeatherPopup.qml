import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets

import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    readonly property real margin: 10
    implicitWidth: columnLayout.implicitWidth + margin * 2
    implicitHeight: columnLayout.implicitHeight + margin * 2
    color: Appearance.colors.colLayer0
    radius: Appearance.rounding.small
    border.width: 1
    border.color: Appearance.colors.colLayer0Border
    clip: true

    ColumnLayout {
        id: columnLayout
        spacing: 5
        anchors.centerIn: root
        implicitWidth: Math.max(header.implicitWidth, gridLayout.implicitWidth)
        implicitHeight: gridLayout.implicitHeight

        // Header
        RowLayout {
            id: header
            spacing: 5
            Layout.fillWidth: parent
            Layout.alignment: Qt.AlignHCenter
            MaterialSymbol {
                fill: 0
                text: "location_on"
                iconSize: Appearance.font.pixelSize.huge
            }

            StyledText {
                text: Weather.data.city
                font.pixelSize: Appearance.font.pixelSize.title
                font.family: Appearance.font.family.title
                color: Appearance.colors.colOnLayer0
            }
        }

        // Metrics grid
        GridLayout {
            id: gridLayout
            columns: 2
            rowSpacing: 5
            columnSpacing: 5
            uniformCellWidths: true

            WeatherCard {
                title: "紫外线指数"
                symbol: "wb_sunny"
                value: Weather.data.uv
            }
            WeatherCard {
                title: "风"
                symbol: "air"
                value: `(${Weather.data.windDir}) ${Weather.data.wind}`
            }
            WeatherCard {
                title: "降水"
                symbol: "rainy_light"
                value: Weather.data.precip
            }
            WeatherCard {
                title: "湿度"
                symbol: "humidity_low"
                value: Weather.data.humidity
            }
            WeatherCard {
                title: "能见度"
                symbol: "visibility"
                value: Weather.data.visib
            }
            WeatherCard {
                title: "气压"
                symbol: "readiness_score"
                value: Weather.data.press
            }
            WeatherCard {
                title: "日出"
                symbol: "wb_twilight"
                value: Weather.data.sunrise
            }
            WeatherCard {
                title: "日落"
                symbol: "bedtime"
                value: Weather.data.sunset
            }
        }
    }
}
