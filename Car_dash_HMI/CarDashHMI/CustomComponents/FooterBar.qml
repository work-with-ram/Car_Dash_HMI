// ******************************************
// ** App Footer Component                 **
// ******************************************
//
// Author: Haseeb Tariq
// Date: September 1, 2023
//
// The App Footer component provides a customizable footer section for your application,
// typically used to display information such as range and odometer values. This component
// includes two text elements:
//
// - 'range': Displays a numeric value, such as a range in miles or kilometers.
// - 'odometer': Shows an odometer reading, often used for tracking distance.
//
// Customize the appearance and content of the 'range' and 'odometer' text elements as
// needed to suit your application's requirements.
//
// Licensing:
// This App Footer component is open-source and available under the GNU General Public License (GPL).
//
// ******************************************
import QtQuick

Item {
    id: mainFooter

    property alias range: rangeValue.text
    property var odometer : 0
    property string driveMode: "SPORT"

    height: parent.height * 0.18
    width: parent.width

    // Sleek Mode Badge at bottom left
    Rectangle {
        id: modeBadge
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: adaptive.height(34)
            horizontalCenterOffset: -adaptive.height(163)
        }
        width: adaptive.width(96)
        height: adaptive.height(28)
        radius: 14
        color: "#0c0e14"
        border.color: driveMode === "SPORT" ? "#FF2A2A" : "#00E676"
        border.width: 1.5

        Behavior on border.color {
            ColorAnimation { duration: 250 }
        }

        Text {
            anchors.centerIn: parent
            text: driveMode
            font.pointSize: adaptive.average(12)
            font.bold: true
            color: driveMode === "SPORT" ? "#FF2A2A" : "#00E676"
            font.family: uniTextFont.name

            Behavior on color {
                ColorAnimation { duration: 250 }
            }
        }
    }

    Text {
        id: rangeValue
        font.pointSize: adaptive.average(13)
        text: "156"
        color: "white"
        font.family: uniTextFont.name
        anchors{
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: adaptive.height(39)
            horizontalCenterOffset: adaptive.height(163)
        }
    }

    Text {
        id: odometerValue
        font.pointSize: adaptive.average(13)
        text: (odometer).toString().padStart(6, '0');
        color: "white"
        font.family: uniTextFont.name
        anchors{
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: adaptive.height(39)
        }
    }
}
