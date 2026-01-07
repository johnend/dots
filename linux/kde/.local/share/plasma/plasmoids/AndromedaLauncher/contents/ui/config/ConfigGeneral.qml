/*****************************************************************************
 *   Copyright (C) 2013-2014 by Eike Hein <hein@kde.org>                     *
 *   Copyright (C) 2021 by Prateek SU <pankajsunal123@gmail.com>             *
 *   Copyright (C) 2022 by Friedrich Schriewer <friedrich.schriewer@gmx.net> *
 *                                                                           *
 *   This program is free software; you can redistribute it and/or modify    *
 *   it under the terms of the GNU General Public License as published by    *
 *   the Free Software Foundation; either version 2 of the License, or       *
 *   (at your option) any later version.                                     *
 *                                                                           *
 *   This program is distributed in the hope that it will be useful,         *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
 *   GNU General Public License for more details.                            *
 *                                                                           *
 *   You should have received a copy of the GNU General Public License       *
 *   along with this program; if not, write to the                           *
 *   Free Software Foundation, Inc.,                                         *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .          *
 ****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs

import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.core as PlasmaCore
import org.kde.draganddrop 2.0 as DragDrop
import org.kde.kirigami 2.3 as Kirigami

import org.kde.ksvg 1.0 as KSvg
import org.kde.plasma.plasmoid 2.0
import org.kde.kcmutils as KCM

import org.kde.iconthemes as KIconThemes


KCM.SimpleKCM {
    id: configGeneral

    property bool isDash: (Plasmoid.pluginName === "org.kde.plasma.kickerdash")

    property string cfg_icon: Plasmoid.configuration.icon
    property bool cfg_useCustomButtonImage: Plasmoid.configuration.useCustomButtonImage
    property string cfg_customButtonImage: Plasmoid.configuration.customButtonImage
    property bool cfg_activationIndicator: Plasmoid.configuration.activationIndicator
    property color cfg_indicatorColor: Plasmoid.configuration.indicatorColor
    property bool cfg_enableGreeting: Plasmoid.configuration.enableGreeting
    property alias cfg_defaultPage: defaultPage.currentIndex
    property alias cfg_pinnedModel: pinnedModel.currentIndex

    property alias cfg_customGreeting: customGreeting.text
    property alias cfg_floating: floating.checked
    property alias cfg_launcherPosition: launcherPosition.currentIndex
    property alias cfg_offsetX: screenOffset.value
    property alias cfg_offsetY: panelOffset.value

    property alias cfg_enableGlow: enableGlowCheck.checked
    property alias cfg_glowColor: glowColor.currentIndex

    property alias cfg_useSystemFontSettings: useSystemFontSettings.checked

  Kirigami.FormLayout {

    anchors.left: parent.left
    anchors.right: parent.right

    Button {
      id: iconButton

      Kirigami.FormData.label: i18n("Icon:")

      implicitWidth: previewFrame.width + Kirigami.Units.smallSpacing * 2
      implicitHeight: previewFrame.height + Kirigami.Units.smallSpacing * 2

      // Just to provide some visual feedback when dragging;
      // cannot have checked without checkable enabled
      checkable: true
      checked: dropArea.containsAcceptableDrag

      onPressed: iconMenu.opened ? iconMenu.close() : iconMenu.open()

      DragDrop.DropArea {
          id: dropArea

          property bool containsAcceptableDrag: false

          anchors.fill: parent

          onDragEnter: {
              // Cannot use string operations (e.g. indexOf()) on "url" basic type.
              var urlString = event.mimeData.url.toString();

              // This list is also hardcoded in KIconDialog.
              var extensions = [".png", ".xpm", ".svg", ".svgz"];
              containsAcceptableDrag = urlString.indexOf("file:///") === 0 && extensions.some(function (extension) {
                  return urlString.indexOf(extension) === urlString.length - extension.length; // "endsWith"
              });

              if (!containsAcceptableDrag) {
                  event.ignore();
              }
          }
          onDragLeave: containsAcceptableDrag = false

          onDrop: {
              if (containsAcceptableDrag) {
                  // Strip file:// prefix, we already verified in onDragEnter that we have only local URLs.
                  iconDialog.setCustomButtonImage(event.mimeData.url.toString().substr("file://".length));
              }
              containsAcceptableDrag = false;
          }
      }

      KIconThemes.IconDialog {
          id: iconDialog

          function setCustomButtonImage(image) {
              configGeneral.cfg_customButtonImage = image || configGeneral.cfg_icon || "start-here-kde-symbolic"
              configGeneral.cfg_useCustomButtonImage = true;
          }

          onIconNameChanged: setCustomButtonImage(iconName);
      }

      KSvg.FrameSvgItem {
          id: previewFrame
          anchors.centerIn: parent
          imagePath: Plasmoid.location === PlasmaCore.Types.Vertical || Plasmoid.location === PlasmaCore.Types.Horizontal
                  ? "widgets/panel-background" : "widgets/background"
          width: Kirigami.Units.iconSizes.large + fixedMargins.left + fixedMargins.right
          height: Kirigami.Units.iconSizes.large + fixedMargins.top + fixedMargins.bottom

          Kirigami.Icon {
              anchors.centerIn: parent
              width: Kirigami.Units.iconSizes.large
              height: width
              source: configGeneral.cfg_useCustomButtonImage ? configGeneral.cfg_customButtonImage : configGeneral.cfg_icon
          }
      }

      Menu {
          id: iconMenu

          // Appear below the button
          y: +parent.height

          onClosed: iconButton.checked = false;

          MenuItem {
              text: i18nc("@item:inmenu Open icon chooser dialog", "Choose…")
              icon.name: "document-open-folder"
              onClicked: iconDialog.open()
          }
          MenuItem {
              text: i18nc("@item:inmenu Reset icon to default", "Clear Icon")
              icon.name: "edit-clear"
              onClicked: {
                  configGeneral.cfg_icon = "start-here-kde-symbolic"
                  configGeneral.cfg_useCustomButtonImage = false
              }
          }
      }
    }
    CheckBox {
      id: activationIndicatorCheck
      Kirigami.FormData.label: i18n("Indicator:")
      text: i18n("Enabled")
      checked: Plasmoid.configuration.activationIndicator
      onCheckedChanged: {
        Plasmoid.configuration.activationIndicator = checked
        cfg_activationIndicator = checked
      }
    }
    Button {
        id: colorButton
        width: Kirigami.Units.iconSizes.small
        height: width
        Kirigami.FormData.label: i18n("Indicator Color:")

        Rectangle {
          anchors.centerIn: parent
          anchors.fill: parent
          radius: 10
          color: cfg_indicatorColor
        }
        onPressed: colorDialog.visible ? colorDialog.close() : colorDialog.open()
        ColorDialog {
          id: colorDialog
          title: i18n("Please choose a color")
          onAccepted: {
              cfg_indicatorColor = colorDialog.selectedColor
          }
        }
    }
    Item {
        Kirigami.FormData.isSection: true
    }
    CheckBox {
      id: enableGreetingCheck
      Kirigami.FormData.label: i18n("Greeting:")
      text: i18n("Enabled")
      checked: Plasmoid.configuration.enableGreeting
      onCheckedChanged: {
        Plasmoid.configuration.enableGreeting = checked
        cfg_enableGreeting = checked
        customGreeting.enabled = checked
      }
    }
    TextField {
      id: customGreeting
      Kirigami.FormData.label: i18n("Custom Greeting Text:")
      placeholderText: i18n("No custom greeting set")
    }
    Item {
        Kirigami.FormData.isSection: true
    }
    CheckBox {
      id: enableGlowCheck
      Kirigami.FormData.label: i18n("Glow")
      text: i18n("Enabled")
      checked: Plasmoid.configuration.enableGlow
      onCheckedChanged: {
        Plasmoid.configuration.enableGlow = checked
      }
    }
    ComboBox {
        id: glowColor
        Kirigami.FormData.label: i18n("Glow color:")
        visible: Plasmoid.configuration.enableGlow
        model: [
            i18n("Purple (Default)"),
            i18n("Blue"),
            i18n("Red"),
        ]
    }
    Item {
        Kirigami.FormData.isSection: true
    }

    ComboBox {
        id: launcherPosition
        Kirigami.FormData.label: i18n("Launcher Positioning:")
        model: [
        i18n("Default"),
        i18n("Horizontal Center"),
        i18n("Screen Center"),
        ]
        onCurrentIndexChanged: {
          if (currentIndex == 2) {
            floating.enabled = false
            floating.checked = true
          } else {
            floating.enabled = true
          }
        }
    }
    CheckBox {
      id: floating
      text: i18n("Floating")
      onCheckedChanged: {
        screenOffset.visible = checked
        panelOffset.visible = checked
      }
    }
    Slider {
      id: screenOffset
      visible: Plasmoid.configuration.floating
      Kirigami.FormData.label: i18n("Offset Screen Edge (0 is Default):")
      from: 0
      value: 0
      to: 100
      stepSize: 1
      PlasmaComponents.ToolTip {
          text: screenOffset.value
      }
    }
    Slider {
      id: panelOffset
      visible: Plasmoid.configuration.floating
      Kirigami.FormData.label: i18n("Offset Panel (0 is Default):")
      from: 0
      value: 0
      to: 100
      stepSize: 1
      PlasmaComponents.ToolTip {
          text: panelOffset.value
      }
    }
    Item {
        Kirigami.FormData.isSection: true
    }
    ComboBox {
        id: pinnedModel
        Kirigami.FormData.label: i18n("Pinned applications Page:")
        model: [
          i18n("Favorites (Default)"),
          i18n("Recent Applications")
        ]
    }
    ComboBox {
        id: defaultPage
        Kirigami.FormData.label: i18n("Default Page:")
        model: [
        i18n("All Applications (Default)"),
        i18n("Developement"),
        i18n("Games"),
        i18n("Graphics"),
        i18n("Internet"),
        i18n("Multimedia"),
        i18n("Office"),
        i18n("Science & Math"),
        i18n("Settings"),
        i18n("System"),
        i18n("Utilities"),
        i18n("Lost & Found"),
        ]
    }

    Item {
      Kirigami.FormData.isSection: true
    }

    CheckBox {
      id: useSystemFontSettings
      Kirigami.FormData.label: i18n("Use system font settings")
      text: i18n("Enabled")
      checked: Plasmoid.configuration.useSystemFontSettings
    }
  }
}
