import QtQuick 2.5

Image {
	id: root
	height: sourceSize.height * zoom
	width: sourceSize.width * zoom

	property real zoom
	property real rrox: 0.5
	property real rroy: 0.5
	property real amin: -45
	property real amax: 45
	property var easing: Easing.Linear
	property int duration: 500

	transform: Rotation {
		id: _rotation
		origin.x: root.rrox * root.width
		origin.y: root.rroy * root.height
		SequentialAnimation on angle {
			running: true
			loops: Animation.Infinite
			NumberAnimation {
				from: root.amin
				to: root.amax
				duration: root.duration
				easing.type: root.easing
			}
			NumberAnimation {
				from: root.amax
				to: root.amin
				duration: root.duration
				easing.type: root.easing
			}
		}
	}
}
