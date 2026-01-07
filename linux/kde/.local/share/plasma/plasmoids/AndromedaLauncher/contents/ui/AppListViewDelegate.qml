/*****************************************************************************
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
import QtQuick 2.12
import QtQuick.Layouts 1.12
import Qt5Compat.GraphicalEffects
import QtQuick.Window 2.2
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.coreaddons 1.0 as KCoreAddons
import org.kde.kirigami 2.13 as Kirigami
import QtQuick.Controls 2.15
import QtQuick.Templates as T
import org.kde.plasma.plasmoid

import "../code/tools.js" as Tools

T.ItemDelegate {
  id: allItem

  property bool compact: Plasmoid.configuration.compactListItems
  
  property int itemHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset, implicitContentHeight + topPadding + bottomPadding)
  
  implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
  implicitHeight: itemHeight
  leftPadding: compact ? 5 : 8
  rightPadding: compact ? 5 : 8
  bottomPadding: compact ? 5 : 8
  topPadding: compact ? 5 : 8

  property bool isDraging: false

  signal aboutToShowActionMenu(variant actionMenu)

  property bool hasActionList: ((model.favoriteId !== null)
      || (("hasActionList" in model) && (model.hasActionList !== null)))

  property var triggerModel

  onAboutToShowActionMenu: {
    var actionList = allItem.hasActionList ? model.actionList : [];
      //Tools.fillActionMenu(i18n, actionMenu, actionList, ListView.view.model.favoritesModel, model.favoriteId);
    Tools.fillActionMenu(i18n, actionMenu, actionList, globalFavorites, model.favoriteId);
  }

  function openActionMenu(x, y) {
    aboutToShowActionMenu(actionMenu);      
    actionMenu.visualParent = allItem;
    actionMenu.open(x, y);
  }
  function actionTriggered(actionId, actionArgument) {
      var close = (Tools.triggerAction(triggerModel, index, actionId, actionArgument) === true);
      if (close) {
          root.toggle();
      }
  }
  function trigger() {
    triggerModel.trigger(index, "", null);
    root.toggle()
  }

 contentItem: RowLayout {
    id: row
    spacing: 8
    Kirigami.Icon {
      id: icon
      implicitWidth: compact ? Kirigami.Units.iconSizes.smallMedium : Kirigami.Units.iconSizes.medium
      implicitHeight: implicitWidth
      Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
      
      source: model.decoration // || root.icon.name || root.icon.source
    }

    GridLayout {
      id: gridLayout

      // readonly property color textColor: root.iconAndLabelsShouldlookSelected ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor

      Layout.fillWidth: true

      rows: allItem.compact ? 1 : 2
      columns: allItem.compact ? 2 : 1
      rowSpacing: 0
      columnSpacing: Kirigami.Units.largeSpacing

      Label {
        id: label
        Layout.fillWidth: !descriptionLabel.visible
        Layout.maximumWidth: allItem.width - allItem.leftPadding - allItem.rightPadding - icon.width - row.spacing
        // Layout.preferredHeight: {
        //     if (root.isCategoryListItem) {
        //         return root.compact ? implicitHeight : Math.round(implicitHeight * 1.5);
        //     }
        //     if (!root.compact && !descriptionLabel.visible) {
        //         return implicitHeight + descriptionLabel.implicitHeight
        //     }
        //     return implicitHeight;
        // }
        text: ("name" in model ? model.name : model.display)
        textFormat: Text.PlainText
        elide: Text.ElideRight
        wrapMode: Text.NoWrap
        verticalAlignment: Text.AlignVCenter
      //   maximumLineCount: root.isMultilineText ? Infinity : 1
        color: main.textColor
      }

      Label {
          id: descriptionLabel
          Layout.fillWidth: true
          visible: text
          // {
          //     let isApplicationSearchResult = root.model?.group === "Applications" || root.model?.group === "System Settings"
          //     let isSearchResultWithDescription = root.isSearchResult && (Plasmoid.configuration?.appNameFormat > 1 || !isApplicationSearchResult)
          //     return text.length > 0 && (isSearchResultWithDescription || (text !== label.text && !root.isCategoryListItem && Plasmoid.configuration?.appNameFormat > 1))
          // }
          opacity: 0.75
          text: model.description
          textFormat: Text.PlainText
          font: Kirigami.Theme.smallFont
          elide: Text.ElideRight
          verticalAlignment: Text.AlignVCenter
          horizontalAlignment: allItem.compact ? Text.AlignRight : Text.AlignLeft
          maximumLineCount: 1
          color: main.textColor
      }
    }
  }

  MouseArea {
      id: ma
      anchors.fill: parent
      z: parent.z + 1
      acceptedButtons: Qt.LeftButton | Qt.RightButton
      cursorShape: Qt.PointingHandCursor
      hoverEnabled: !listView.movedWithWheel && !listView.blockingHoverFocus
      onClicked: {
          if (mouse.button == Qt.RightButton) {
            if (allItem.hasActionList) {
              var mapped = mapToItem(allItem, mouse.x, mouse.y);
              allItem.openActionMenu(mapped.x, mapped.y);
            }
          } else {
            trigger()
          }
        
      }
      onReleased: {
        isDraging: false
      }

      onEntered: {
          // - When the movedWithKeyboard condition is broken, we do not want to
          //   select the hovered item without moving the mouse.
          // - Don't highlight separators.
          // - Don't switch category items on hover if the setting isn't enabled
          if (listView.movedWithKeyboard) {
              return
          }

          // forceActiveFocus() touches multiple items, so check for
          // activeFocus first to be more efficient.
          if (!listView.activeFocus) {
              listView.forceActiveFocus(Qt.MouseFocusReason)
          }
          // No need to check currentIndex first because it's
          // built into QQuickListView::setCurrentIndex() already
          listView.currentIndex = index
      }
      onPositionChanged: {
        isDraging = pressed
        if (pressed){
          if ("pluginName" in model) {
            dragHelper.startDrag(kicker, model.url, model.decoration,
                "text/x-plasmoidservicename", model.pluginName);
          } else {
            dragHelper.startDrag(kicker, model.url, model.decoration);
          }
        }
      }
  }
  ActionMenu {
      id: actionMenu

      onActionClicked: {
          visualParent.actionTriggered(actionId, actionArgument);
      }
  }
}
