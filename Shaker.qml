import QtQuick 2.5

Item {
	id:root
	height: bg.sourceSize.height
	width: bg.sourceSize.width

	property real zoom: bg.height / bg.sourceSize.height

	Image {
		id: bg
		height: Math.min(parent.height,
						 sourceSize.height / sourceSize.width * parent.width)
		width: Math.min(parent.width,
						sourceSize.width / sourceSize.height * parent.height)
		fillMode: Image.PreserveAspectFit
		source: "bg.xcf"

		ShakeLayer {
			id: l1
			source: "1.xcf"
			zoom:root.zoom
			amin: -10
			amax: 10
			easing: Easing.OutBack
			duration: 500
		}

		ShakeLayer {
			id: l2
			source: "2.xcf"
			zoom:root.zoom
			amin: 4
			amax: -4
			easing: Easing.Linear
			duration: 500
		}

		Rectangle {
			visible: false
			color: "transparent"
			border.width: 1
			border.color: "red"
			anchors.fill: parent
		}

		MouseArea {
			anchors.fill: parent
			acceptedButtons: Qt.LeftButton | Qt.RightButton
			onClicked: {
				drip.cx = mouseX
				drip.cy = mouseY
				if (mouse.button == Qt.RightButton) {
					drip.color = "#6ABAFF"
					l2.rrox = mouseX / l2.width
					l2.rroy = mouseY / l2.height
				} else {
					drip.color = "#FF7070"
					l1.rrox = mouseX / l1.width
					l1.rroy = mouseY / l1.height
				}
				dripAnime.start()
			}

			property int startX
			property int startY
			onPressedChanged: {
				startX = mouseX
				startY = mouseY
			}

			onPositionChanged: {
				console.log(l1.amin, l1.amax)
				l1.amax += mouseX - startX
				l1.amin -= mouseX - startX
				l2.amax += mouseY - startY
				l2.amin -= mouseY - startY
				startX = mouseX
				startY = mouseY
			}
		}

		Rectangle {
			id: drip
			property int cx
			property int cy
			x: cx - width / 2
			y: cy - height / 2
			width: height
			radius: height
			opacity: .5 - height / 50 / 2
			NumberAnimation on height {
				id: dripAnime
				from: 10
				to: 50
				duration: 200
			}
			onOpacityChanged: {
				if (opacity == 0) recorder.start()
			}
		}

		Timer{
			id:recorder
			interval:1000./30 + 1000
			repeat: true
			property int cnt: 0
			function save(data){
				var s = "/tmp/Shaker_"+cnt+".png";
				console.log("Grab saved as " + s)
				data.saveToFile(s)
			}
			onRunningChanged: {
				if (running) cnt = 0;
			}

			onTriggered: {
				bg.grabToImage(save, Qt.size(bg.width, bg.height))
				cnt += 1;
				if (cnt >= 30) stop();
			}
		}

	}
}
