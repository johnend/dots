export const Utilities = () =>
  Widget.Box({
    hpack: "end",
    spacing: 8,
    className: "utilities",
    children: [
      Widget.Icon({
        icon: "rocket",
      }),
      Widget.Icon({
        icon: "settings",
      }),
      Widget.Icon({
        icon: "notifications-message",
      }),
      Widget.Icon({
        icon: "lightbulb",
      }),
    ],
  });
