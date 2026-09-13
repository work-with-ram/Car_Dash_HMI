// ******************************************
// ** Bar Indicator Component Usage        **
// ******************************************
//
// Author: Haseeb Tariq
// Date: August 31, 2023
//
// The custom Bar Indicator component is designed to visualize a value within a specified
// range using a four-bar indicator. It allows you to display the value as a series of bars,
// each representing a different level based on the input 'value' and 'maxValue' properties.
//
// Key Features:
// - Customize the position and appearance of the Bar Indicator within your user interface.
// - Set the 'value' property to represent the value you want to visualize.
// - Define the 'maxValue' property to establish the upper limit of the range.
// - Optionally, set 'leftMirrorInvert' to create a mirror effect for the indicator (default: false).
//
// The Bar Indicator has five states, and the number of bars illuminated depends on the percentage
// of the 'value' within the 'maxValue' range:
// - 'zeroBar': No bars are illuminated.
// - 'oneBar': The first bar is illuminated.
// - 'twoBar': The first and second bars are illuminated.
// - 'threeBar': The first, second, and third bars are illuminated.
// - 'fourBar': All four bars are illuminated.
//
// Licensing:
// This Bar Indicator component is open-source and available under the GNU General Public License (GPL).
//
// ******************************************


import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    id: mainBarIndicator

    property double value: 0
    property double maxValue: 100
    property bool leftMirrorInvert: false
    property double percent: (value / maxValue) * 100
    property color barColor: "#FF2A2A"

    width: adaptive.width(98)
    height: adaptive.height(131)

    // Transformation for mirror or un mirror effect
    transform:  [
        Scale{ xScale: leftMirrorInvert ?  -1 : 1}
    ]

    // Different bar state images
    Item {
        id: barOneContainer
        anchors.fill: parent
        opacity: 0.2

        Image{
            id: barOne
            source:"qrc:/Assets/Images/BarIndicator/BarIndicatorOne.png"
            anchors.fill: parent
            visible: false
        }
        ColorOverlay {
            anchors.fill: barOne
            source: barOne
            color: mainBarIndicator.barColor
        }
    }

    Item {
        id: barTwoContainer
        anchors.fill: parent
        opacity: 0.2

        Image{
            id: barTwo
            source:"qrc:/Assets/Images/BarIndicator/BarIndicatorTwo.png"
            anchors.fill: parent
            visible: false
        }
        ColorOverlay {
            anchors.fill: barTwo
            source: barTwo
            color: mainBarIndicator.barColor
        }
    }

    Item {
        id: barThreeContainer
        anchors.fill: parent
        opacity: 0.2

        Image{
            id: barThree
            source:"qrc:/Assets/Images/BarIndicator/BarIndicatorThree.png"
            anchors.fill: parent
            visible: false
        }
        ColorOverlay {
            anchors.fill: barThree
            source: barThree
            color: mainBarIndicator.barColor
        }
    }

    Item {
        id: barFourContainer
        anchors.fill: parent
        opacity: 0.2

        Image{
            id: barFour
            source: "qrc:/Assets/Images/BarIndicator/BarIndicatorFour.png"
            anchors.fill: parent
            visible: false
        }
        ColorOverlay {
            anchors.fill: barFour
            source: barFour
            color: mainBarIndicator.barColor
        }
    }

    // Five states on bar images on scale from 0 to 100
    states: [
        State {
            name: "zeroBar" ; when : mainBarIndicator.percent < 25
            PropertyChanges { target: barOneContainer; opacity: 0.2}
            PropertyChanges { target: barTwoContainer; opacity: 0.2}
            PropertyChanges { target: barThreeContainer; opacity: 0.2}
            PropertyChanges { target: barFourContainer; opacity: 0.2}

        },
        State {
            name: "oneBar" ; when : mainBarIndicator.percent >= 25 && mainBarIndicator.percent < 50
            PropertyChanges { target: barOneContainer; opacity: 1}
            PropertyChanges { target: barTwoContainer; opacity: 0.2}
            PropertyChanges { target: barThreeContainer; opacity: 0.2}
            PropertyChanges { target: barFourContainer; opacity: 0.2}

        },
        State {
            name: "twoBar" ;  when : mainBarIndicator.percent >= 50 && mainBarIndicator.percent < 75
            PropertyChanges { target: barOneContainer; opacity: 1}
            PropertyChanges { target: barTwoContainer; opacity: 1}
            PropertyChanges { target: barThreeContainer; opacity: 0.2}
            PropertyChanges { target: barFourContainer; opacity: 0.2}

        },
        State {
            name: "threeBar" ; when : mainBarIndicator.percent >= 75 && mainBarIndicator.percent < 95
            PropertyChanges { target: barOneContainer; opacity: 1}
            PropertyChanges { target: barTwoContainer; opacity: 1}
            PropertyChanges { target: barThreeContainer; opacity: 1}
            PropertyChanges { target: barFourContainer; opacity: 0.2}

        },
        State {
            name: "fourBar" ; when : mainBarIndicator.percent > 90
            PropertyChanges { target: barOneContainer; opacity: 1}
            PropertyChanges { target: barTwoContainer; opacity: 1}
            PropertyChanges { target: barThreeContainer; opacity: 1}
            PropertyChanges { target: barFourContainer; opacity: 1}
        }
    ]
}
