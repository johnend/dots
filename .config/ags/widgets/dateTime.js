import {
  weekdayLabel,
  dateLabel,
  hoursLabel,
  minutesLabel,
} from "../lib/dateTime.js";

export const DateTime = () =>
  Widget.Box({
    className: "date-time",
    children: [
      Widget.Icon({
        className: "watch-circle",
        icon: "watch-circle",
      }),
      Widget.Label({
        className: "weekday",
        label: weekdayLabel.bind().as((weekday) => `${weekday}`),
      }),
      Widget.Label({
        className: "date",
        label: dateLabel.bind().as((date) => `${date} `),
      }),
      Widget.Label({
        className: "hours",
        label: hoursLabel.bind().as((hours) => `${hours}`),
      }),
      Widget.Label({
        className: "time-separator",
        label: ":",
      }),
      Widget.Label({
        className: "minutes",
        label: minutesLabel.bind().as((minutes) => `${minutes}`),
      }),
    ],
  });
