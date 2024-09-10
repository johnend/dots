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

const scssDir = `${App.configDir}/styles`;
const scss = `${App.configDir}/styles/main.scss`;
const css = `/tmp/ags/main.css`;
Utils.exec(`sass ${scss} ${css}`);

Utils.monitorFile(scssDir, function () {
  Utils.exec(`sass ${scss} ${css}`);
  App.resetCss();
  App.applyCss(css);
});

App.config({
  style: css,
  windows: [Bar(2)],
});
