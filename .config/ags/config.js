import { Utilities } from "./widgets/utilities.js";
import { DateTime } from "./widgets/dateTime.js";
import { Workspaces } from "./widgets/workspaces.js";

const Bar = (/** @type {number} */ monitor) =>
  Widget.Window({
    monitor,
    name: `bar${monitor}`,
    className: "window",
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
      start_widget: Workspaces(),
      centerWidget: DateTime(),
      // Should contain interactive items
      end_widget: Utilities(),
    }),
  });

App.addIcons(`${App.configDir}/assets`);
App.config({
  style: "./styles.css",
  windows: [Bar(2)],
});
