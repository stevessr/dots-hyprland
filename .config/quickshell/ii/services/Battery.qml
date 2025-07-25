pragma Singleton

import qs
import qs.modules.common
import Quickshell
import Quickshell.Services.UPower

Singleton {
    property bool available: UPower.displayDevice.isLaptopBattery
    property var chargeState: UPower.displayDevice.state
    property bool isCharging: chargeState == UPowerDeviceState.Charging
    property bool isPluggedIn: isCharging || chargeState == UPowerDeviceState.PendingCharge
    property real percentage: UPower.displayDevice.percentage
    readonly property bool allowAutomaticSuspend: Config.options.battery.automaticSuspend

    property bool isLow: percentage <= Config.options.battery.low / 100
    property bool isCritical: percentage <= Config.options.battery.critical / 100
    property bool isSuspending: percentage <= Config.options.battery.suspend / 100

    property bool isLowAndNotCharging: isLow && !isCharging
    property bool isCriticalAndNotCharging: isCritical && !isCharging
    property bool isSuspendingAndNotCharging: allowAutomaticSuspend && isSuspending && !isCharging

    onIsLowAndNotChargingChanged: {
        if (available && isLowAndNotCharging) Quickshell.execDetached([
            "notify-send", 
            "电量低",
            "请考虑插入充电器",
            "-u", "critical",
            "-a", "Shell"
        ])
    }

    onIsCriticalAndNotChargingChanged: {
        if (available && isCriticalAndNotCharging) Quickshell.execDetached([
            "notify-send", 
            "电量严重不足",
            qsTr("请充电！\n将在 %1 时自动休眠").arg(Config.options.battery.suspend),
            "-u", "critical",
            "-a", "Shell"
        ]);
            
    }

    onIsSuspendingAndNotChargingChanged: {
        if (available && isSuspendingAndNotCharging) {
            Quickshell.execDetached(["bash", "-c", `systemctl suspend || loginctl suspend`]);
        }
    }
}
