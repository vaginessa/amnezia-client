import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15
import ProtocolEnum 1.0
import "../"
import "../../Controls"
import "../../Config"

PageShareProtocolBase {
    id: root
    protocol: ProtocolEnum.WireGuard

    BackButton {
        id: back
    }
    Caption {
        id: caption
        text: qsTr("Share WireGuard Settings")
    }

    FlickableType {
        id: fl
        anchors.top: caption.bottom
        contentHeight: content.height

        ColumnLayout {
            id: content
            enabled: logic.pageEnabled
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: 15

            LabelType {
                id: lb_desc
                Layout.fillWidth: true
                Layout.topMargin: 10

                horizontalAlignment: Text.AlignHCenter

                wrapMode: Text.Wrap
                text: qsTr("New encryption keys pair will be generated.")
            }

            ShareConnectionButtonType {
                Layout.topMargin: 10
                Layout.fillWidth: true
                Layout.preferredHeight: 40

                text: genConfigProcess ? generatingConfigText : generateConfigText
                onClicked: {
                    enabled = false
                    genConfigProcess = true
                    ShareConnectionLogic.onPushButtonShareWireGuardGenerateClicked()
                    enabled = true
                    genConfigProcess = false
                }
            }

            TextAreaType {
                id: tfShareCode

                Layout.topMargin: 20
                Layout.preferredHeight: 200
                Layout.fillWidth: true

                textArea.readOnly: true
                textArea.wrapMode: TextEdit.WrapAnywhere
                textArea.verticalAlignment: Text.AlignTop
                textArea.text: ShareConnectionLogic.textEditShareWireGuardCodeText

                visible: tfShareCode.textArea.length > 0
            }
            ShareConnectionButtonCopyType {
                Layout.preferredHeight: 40
                Layout.fillWidth: true

                copyText: tfShareCode.textArea.text
            }

            ShareConnectionButtonType {
                Layout.preferredHeight: 40
                Layout.fillWidth: true

                text: Qt.platform.os === "android" ? qsTr("Share") : qsTr("Save to file")
                enabled: tfShareCode.textArea.length > 0
                visible: tfShareCode.textArea.length > 0

                onClicked: {
                    UiLogic.saveTextFile(qsTr("Save OpenVPN config"), "amnezia_for_wireguard.conf", "*.conf", tfShareCode.textArea.text)
                }
            }

            Image {
                Layout.topMargin: 20
                Layout.fillWidth: true
                Layout.preferredHeight: width
                smooth: false
                source: ShareConnectionLogic.shareWireGuardQrCodeText
            }
        }
    }
}
