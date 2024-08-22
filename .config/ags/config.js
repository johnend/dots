const currentDate = new Date();
const dateOptions = {
  weekday: "short", // long, short, narrow
  day: "numeric", // numeric, 2-digit
  year: "numeric", // numeric, 2-digit
  month: "short", // numeric, 2-digit, long, short, narrow
  hour: "numeric", // numeric, 2-digit
  minute: "numeric", // numeric, 2-digit
  second: "numeric", // numeric, 2-digit
};

const time = Variable("", {
  poll: [
    1000,
    function () {
      return currentDate.toLocaleString("en-gb", dateOptions);
    },
  ],
});

const Bar = (/** @type {number} */ monitor) =>
  Widget.Window({
    monitor,
    name: `bar${monitor}`,
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
      start_widget: Widget.Label({
        hpack: "center",
        label: "Welcome to AGS!",
      }),
      end_widget: Widget.Label({
        hpack: "center",
        label: time.bind(),
      }),
    }),
  });

App.config({
  windows: [Bar(2)],
});

