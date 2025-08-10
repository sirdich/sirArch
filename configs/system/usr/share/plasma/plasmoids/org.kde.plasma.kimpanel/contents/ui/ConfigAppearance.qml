/*
    SPDX-FileCopyrightText: 2014 Weng Xuetian <wengxt@gmail.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.5
import QtQuick.Controls 2.5 as QQC2
import QtQuick.Dialogs 6.3 as QtDialogs
import QtQuick.Layouts 1.0
import org.kde.plasma.plasmoid 2.0

import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property bool cfg_vertical_lookup_table
    property bool cfg_use_default_font
    property font cfg_font
    property bool cfg_scaleIconsToFit

    Kirigami.FormLayout {
        QQC2.ButtonGroup { id: layoutRadioGroup }
        QQC2.ButtonGroup { id: scaleRadioGroup }

        QQC2.RadioButton {
            id: verticalLayoutRadioButton
            Kirigami.FormData.label: i18n("Input method list:")
            text: i18n("Vertical")
            checked: cfg_vertical_lookup_table == true
            onToggled: cfg_vertical_lookup_table = checked
            QQC2.ButtonGroup.group: layoutRadioGroup
        }
        QQC2.RadioButton {
            text: i18n("Horizontal")
            checked: cfg_vertical_lookup_table == false
            onToggled: cfg_vertical_lookup_table = !checked
            QQC2.ButtonGroup.group: layoutRadioGroup
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Font:")

            QQC2.CheckBox {
                id: useCustomFont
                checked: !cfg_use_default_font
                onClicked: cfg_use_default_font = !checked
                text: i18n("Use custom:")
            }

            QQC2.TextField {
                enabled: useCustomFont.checked
                readOnly: true
                text: i18nc("The selected font family and font size", font.family + " " + font.pointSize + "pt")
                font: cfg_font
                Layout.fillHeight: true
            }

            QQC2.Button {
                enabled: useCustomFont.checked
                icon.name: "document-edit"
                onClicked: fontDialog.open();

                QQC2.ToolTip {
                    visible: parent.hovered
                    text: i18n("Select Font…")
                }
            }
        }

        QQC2.RadioButton {
            Kirigami.FormData.label: i18nc("The arrangement of icons in the Panel", "Panel icon size:")
            text: i18n("Small")
            checked: cfg_scaleIconsToFit == false
            onToggled: cfg_scaleIconsToFit = !checked
            QQC2.ButtonGroup.group: scaleRadioGroup
        }
        QQC2.RadioButton {
            id: automaticScaleRadioButton
            text: Plasmoid.formFactor === PlasmaCore.Types.Horizontal ? i18n("Scale with Panel height")
                                                                        : i18n("Scale with Panel width")
            checked: cfg_scaleIconsToFit == true
            onToggled: cfg_scaleIconsToFit = checked
            QQC2.ButtonGroup.group: scaleRadioGroup
        }

        QtDialogs.FontDialog {
            id: fontDialog
            title: i18nc("@title:window", "Select Font")

            selectedFont: !cfg_font || cfg_font.family === "" ? Kirigami.Theme.defaultFont : cfg_font

            onAccepted: {
                cfg_font = selectedFont
            }
        }
    }
}
