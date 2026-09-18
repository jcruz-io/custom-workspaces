import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "jcruz.custom-workspaces"

  // Nerd Font glyphs for workspaces 1..10. Codepoints above U+FFFF are written
  // as UTF-16 surrogate pairs. Override with an "icons" array in shell.json.
  readonly property var defaultIcons: [
    "",        //  1  nf-fa-chrome
    "󰟀",  //  2  U+F07C0
    "󰒋",  //  3  U+F048B
    "󰇥",  //  4  U+F01E5
    "",        //  5  U+F14B
    "",        //  6  nf-fa-folder
    "󰅶",  //  7  U+F0176
    "",        //  8  nf-fa-video_camera
    "󰃖",  //  9  U+F00D6
    ""         // 10  nf-fa-comments
  ]
  readonly property string defaultActiveIcon: ""

  readonly property var icons: root.setting("icons", root.defaultIcons)
  readonly property string activeIcon: root.setting("activeIcon", root.defaultActiveIcon)
  readonly property int persistent: Math.max(0, Math.min(10, root.setting("persistent", 10)))

  function workspaceById(id) {
    var values = Hyprland.workspaces.values
    for (var i = 0; i < values.length; i++) {
      if (values[i].id === id) return values[i]
    }

    return null
  }

  function workspaceIds() {
    var ids = []
    for (var n = 1; n <= root.persistent; n++) ids.push(n)

    var values = Hyprland.workspaces.values
    for (var i = 0; i < values.length; i++) {
      var id = values[i].id
      if (id > 0 && id <= 10 && ids.indexOf(id) === -1) ids.push(id)
    }

    ids.sort(function(left, right) { return left - right })
    return ids
  }

  function iconFor(id, focused) {
    if (focused && root.activeIcon !== "") return root.activeIcon
    var icon = root.icons && root.icons.length >= id ? root.icons[id - 1] : ""
    if (icon) return String(icon)
    return id === 10 ? "0" : String(id)
  }

  function focusWorkspace(id) {
    if (!root.bar) return
    root.bar.run("hyprctl dispatch " + Util.shellQuote("hl.dsp.focus({ workspace = \"" + id + "\" })"))
  }

  readonly property real trailingGap: root.vertical ? 0 : Style.spaceReal(1.5)

  implicitWidth: grid.implicitWidth + trailingGap
  implicitHeight: grid.implicitHeight

  GridLayout {
    id: grid
    anchors.fill: parent
    anchors.rightMargin: root.trailingGap
    columns: root.vertical ? 1 : root.workspaceIds().length
    columnSpacing: root.vertical ? 0 : Style.space(1)
    rowSpacing: root.vertical ? Style.space(2) : 0

    Repeater {
      model: root.workspaceIds()

      WidgetButton {
        required property int modelData

        readonly property var workspace: root.workspaceById(modelData)
        readonly property bool occupied: workspace !== null && workspace.toplevels.values.length > 0
        readonly property bool focused: Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === modelData

        bar: root.bar
        text: root.iconFor(modelData, focused)
        opacity: occupied || focused ? 1 : 0.5
        horizontalMargin: 6
        verticalPadding: 6
        fixedWidth: root.vertical ? root.barSize : Style.space(20)
        fixedHeight: root.barSize
        onPressed: function() { root.focusWorkspace(modelData) }
      }
    }
  }
}
