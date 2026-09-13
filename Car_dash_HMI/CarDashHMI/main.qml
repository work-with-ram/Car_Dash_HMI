import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQml
import "qrc:/CustomComponents"
import "qrc:/JavascriptScripts/AdaptiveLayoutManager.js" as Responsive

ApplicationWindow {
    id: mainWindow

    property var adaptive: new Responsive.AdaptiveLayoutManager(1219,487, mainWindow.width,mainWindow.height)

    // Drive Mode: "SPORT" or "ECO"
    property string currentDriveMode: "SPORT"
    property color themeColor: currentDriveMode === "SPORT" ? "#E50914" : "#00E676"
    property color glowColor: currentDriveMode === "SPORT" ? "#FF1E27" : "#00E676"

    // Driving values
    property double speedValue: 0
    property double rpmValue: 0
    property bool isAccelerating: false
    property bool isBraking: false
    property double distanceDriven: 0
    property double fuelBarValue: 100.0
    property double temperatureBarValue: 45.0
    property double odometer: 786.0
    property int range: 156

    function toggleDriveMode() {
        if (currentDriveMode === "SPORT") {
            currentDriveMode = "ECO";
        } else {
            currentDriveMode = "SPORT";
        }
    }

    width: 1219
    height: 487
    visible: true
    title: qsTr("CarDashHMI")

    onWidthChanged: {
        if(adaptive)
            adaptive.updateWindowWidth(mainWindow.width)
    }

    onHeightChanged: {
        if(adaptive)
            adaptive.updateWindowHeight(mainWindow.height)
    }

    background: Image {
        id: background
        width: adaptive.width(1219)
        height: adaptive.height(487)
        source: "qrc:/Assets/Images/Background/Background.png"
    }

    FontLoader {
        id: uniTextFont
        source: "qrc:/Assets/Fonts/Unitext Regular.ttf"
    }

    // Keyboard Controller for Acceleration (Forward / Up arrow / W)
    Item {
        id: keyHandler
        anchors.fill: parent
        focus: true

        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Up || event.key === Qt.Key_W || event.key === Qt.Key_PageUp || event.key === Qt.Key_Right) {
                mainWindow.isAccelerating = true;
                event.accepted = true;
            } else if (event.key === Qt.Key_Down || event.key === Qt.Key_S || event.key === Qt.Key_Space) {
                mainWindow.isBraking = true;
                event.accepted = true;
            } else if (event.key === Qt.Key_M) {
                mainWindow.toggleDriveMode();
                event.accepted = true;
            }
        }

        Keys.onReleased: function(event) {
            if (event.key === Qt.Key_Up || event.key === Qt.Key_W || event.key === Qt.Key_PageUp || event.key === Qt.Key_Right) {
                mainWindow.isAccelerating = false;
                event.accepted = true;
            } else if (event.key === Qt.Key_Down || event.key === Qt.Key_S || event.key === Qt.Key_Space) {
                mainWindow.isBraking = false;
                event.accepted = true;
            }
        }

        Component.onCompleted: keyHandler.forceActiveFocus()
    }

    MouseArea {
        anchors.fill: parent
        z: -1
        onClicked: keyHandler.forceActiveFocus()
    }

    // Smooth Acceleration & Driving Physics (60 FPS)
    Timer {
        id: drivePhysics
        interval: 16
        running: true
        repeat: true
        onTriggered: {
            var isSport = (mainWindow.currentDriveMode === "SPORT");
            var maxSpd = isSport ? 280 : 130;
            var maxR = isSport ? 8.0 : 5.0;
            var accelStep = isSport ? 1.8 : 0.85;

            // Acceleration
            if (mainWindow.isAccelerating) {
                mainWindow.speedValue = Math.min(maxSpd, mainWindow.speedValue + accelStep);
                mainWindow.rpmValue = Math.min(maxR, (mainWindow.speedValue / maxSpd) * maxR);
            }
            // Braking
            else if (mainWindow.isBraking) {
                mainWindow.speedValue = Math.max(0, mainWindow.speedValue - 3.5);
                mainWindow.rpmValue = Math.max(0, (mainWindow.speedValue / maxSpd) * maxR);
            }
            // Coasting
            else {
                mainWindow.speedValue = Math.max(0, mainWindow.speedValue - 0.35);
                mainWindow.rpmValue = Math.max(0, (mainWindow.speedValue / maxSpd) * maxR);
            }

            // Odometer & Fuel consumption: for every 10 km driven, fuel reduces by 1
            if (mainWindow.speedValue > 0) {
                var deltaKm = (mainWindow.speedValue / 3600.0) * 0.016 * 5.0;
                mainWindow.odometer += deltaKm;
                mainWindow.distanceDriven += deltaKm;

                // Fuel decreases by 1 unit for every 10 km driven
                var fuelDrops = Math.floor(mainWindow.distanceDriven / 10.0);
                mainWindow.fuelBarValue = Math.max(0, 100.0 - fuelDrops);

                // Range updates dynamically with remaining fuel
                mainWindow.range = Math.max(0, Math.round((mainWindow.fuelBarValue / 100.0) * 156.0));
            }

            // Engine Heat / Temperature Dynamics (Coolant & Oil Temperature)
            // Normal operating temperature sits at 50% (~90°C)
            // Aggressive driving / high RPM / high speed generates heat up to ~85-90%
            // Cruising / idling / coasting allows the radiator to cool back to 50%
            var baseTemp = 50.0;
            var loadHeat = (mainWindow.speedValue / maxSpd) * (isSport ? 35.0 : 15.0) + (mainWindow.rpmValue / maxR) * (isSport ? 12.0 : 5.0);
            var targetTemp = baseTemp + loadHeat;
            // Smooth thermal inertia (engine heats up and cools down gradually)
            mainWindow.temperatureBarValue += (targetTemp - mainWindow.temperatureBarValue) * 0.015;
        }
    }

    // Top Tool Bar (Time, Weather, Date in "dd MMM yyyy")
    ToolBar{
        id: toolBar
    }

    // Left RPM Gauge
    Gauge{
        id: rpmGauge
        x: adaptive.width(59)
        y: adaptive.height(50)
        z: 2
        gaugeValueUnitText.text: "rpm/1000"
        gaugeValueText: Math.round(value).toString()
        value: mainWindow.rpmValue
        maxValue: 8
        primaryColor: mainWindow.themeColor
        accentGlowColor: mainWindow.glowColor
        alertThemeActivate: rpmGauge.value >= 6
    }

    // Right Speed Gauge
    Gauge{
        id: speedGauge
        x: adaptive.width(767)
        y: adaptive.height(50)
        z: 2
        gaugeValueUnitText.text: "km/h"
        gaugeValueText: Math.round(value).toString()
        value: mainWindow.speedValue
        maxValue: 280
        gaugeShadow.horizontalOffset: -3
        primaryColor: mainWindow.themeColor
        accentGlowColor: mainWindow.glowColor
        alertThemeActivate: rpmGauge.value >= 6
    }

    // Left Temperature Bar Indicator (Engine Coolant & Heat)
    BarIndicator{
        id: temperatureBar
        value: mainWindow.temperatureBarValue
        maxValue: 100
        x: adaptive.width(28)
        y: adaptive.height(289)
        barColor: mainWindow.themeColor
    }

    // Right Fuel Bar Indicator
    BarIndicator{
        id: fuelBar
        x: adaptive.width(1192)
        y: adaptive.height(289)
        maxValue: 100
        value: mainWindow.fuelBarValue
        leftMirrorInvert: true
        barColor: mainWindow.themeColor
    }

    // Center Section: Navigation Map & Mode Switch
    MenuSection{
        id: menuSection
        driveMode: mainWindow.currentDriveMode
        themeColor: mainWindow.themeColor
    }

    // Footer Bar (Odometer, Range, Drive Mode)
    FooterBar{
        id: footerbar
        odometer: Math.floor(mainWindow.odometer)
        range: mainWindow.range
        driveMode: mainWindow.currentDriveMode
        anchors{
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
    }
}
