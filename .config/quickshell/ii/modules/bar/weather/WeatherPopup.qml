import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets

import QtQuick
import QtQuick.Layouts
import "../"

StyledPopup {
    id: root

    ColumnLayout {
        id: columnLayout
        anchors.centerIn: parent
        implicitWidth: Math.max(header.implicitWidth, gridLayout.implicitWidth)
        implicitHeight: gridLayout.implicitHeight
        spacing: 5

        // Header
        ColumnLayout {
            id: header
            Layout.alignment: Qt.AlignHCenter
            spacing: 2

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 6

                MaterialSymbol {
                    fill: 0
                    font.weight: Font.Medium
                    text: "location_on"
                    iconSize: Appearance.font.pixelSize.large
                    color: Appearance.colors.colOnSurfaceVariant
                }

                StyledText {
                    text: Weather.data.city
                    font {
                        weight: Font.Medium
                        pixelSize: Appearance.font.pixelSize.normal
                    }
                    color: Appearance.colors.colOnSurfaceVariant
                }
            }
            StyledText {
                id: temp
                font.pixelSize: Appearance.font.pixelSize.smaller
                color: Appearance.colors.colOnSurfaceVariant
                text: Weather.data.temp + " • " + Translation.tr("Feels like %1").arg(Weather.data.tempFeelsLike)
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