import QtQuick
import QtQuick.Controls
import QtQml
import "qrc:/CustomComponents/Pages"

Rectangle{
    id: menuSectionRoot

    property string driveMode: "SPORT"
    property color themeColor: "#E50914"

    anchors.centerIn: parent
    width:  adaptive.width(500)
    height: adaptive.height(300)
    color: "black"
    visible: true
    clip: true

    // Map Page
    PageMap{
        id: pageMap
        anchors.fill: parent
        visible: true
    }

    // Custom Sliding ECO / SPORT Mode Switch Capsule
    Rectangle {
        id: modeSwitchCapsule
        anchors {
            top: parent.top
            topMargin: adaptive.height(14)
            horizontalCenter: parent.horizontalCenter
        }
        width: adaptive.width(180)
        height: adaptive.height(34)
        radius: 17
        color: "#0d1017"
        border.color: Qt.rgba(themeColor.r, themeColor.g, themeColor.b, 0.45)
        border.width: 1.5
        z: 10

        // Sliding Active Indicator Pill
        Rectangle {
            id: activeSliderPill
            width: parent.width / 2 - 4
            height: parent.height - 6
            radius: 14
            y: 3
            x: driveMode === "ECO" ? 3 : parent.width / 2 + 1
            color: driveMode === "ECO" ? "#00E676" : "#E50914"

            Behavior on x {
                NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
            }
            Behavior on color {
                ColorAnimation { duration: 250 }
            }
        }

        // Clickable Labels Row (Clean Text, No Emojis)
        Row {
            anchors.fill: parent

            // ECO Option
            Item {
                width: parent.width / 2
                height: parent.height

                Text {
                    anchors.centerIn: parent
                    text: "ECO"
                    font.pixelSize: adaptive.average(12)
                    font.bold: driveMode === "ECO"
                    font.family: uniTextFont.name
                    color: driveMode === "ECO" ? "black" : "#8894a6"
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (driveMode !== "ECO") {
                            mainWindow.toggleDriveMode();
                        }
                    }
                }
            }

            // SPORT Option
            Item {
                width: parent.width / 2
                height: parent.height

                Text {
                    anchors.centerIn: parent
                    text: "SPORT"
                    font.pixelSize: adaptive.average(12)
                    font.bold: driveMode === "SPORT"
                    font.family: uniTextFont.name
                    color: driveMode === "SPORT" ? "white" : "#8894a6"
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (driveMode !== "SPORT") {
                            mainWindow.toggleDriveMode();
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        pageMap.startAnimation()
    }
}
