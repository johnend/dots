const hyprland = await Service.import("hyprland");

export function Workspaces() {
  const activeId = hyprland.active.workspace.bind("id");
  const workspaces = hyprland.bind("workspaces").as((ws) =>
    ws
      // remove random negative workspace
      .filter(({ id }) => id > 0)
      // sort remaining workspaces (not done by default in AGS)
      .sort(({ id: a }, { id: b }) => a - b)
      .map(({ id }) =>
        Widget.Button({
          className: "workspace-button",
          onClicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
          child: Widget.Icon({
            icon: activeId.as(
              (i) => `${i === id ? "sticker-circle" : "circle"}`,
            ),
          }),
        }),
      ),
  );
  return Widget.Box({
    hpack: "start",
    spacing: 8,
    className: "workspaces",
    children: workspaces,
  });
}
