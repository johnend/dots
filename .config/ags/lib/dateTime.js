export const weekdayLabel = Variable("", {
  poll: [
    1000,
    function () {
      const date = new Date();
      const shortDayName = (
        /** @type {Date} */ date,
        /** @type {undefined} */ locale,
      ) => {
        return date.toLocaleString(locale, { weekday: "short" });
      };
      // return formatter.format(new Date());
      return `${shortDayName(date)}, `;
    },
  ],
});

export const dateLabel = Variable("", {
  poll: [
    100000,
    function () {
      const date = new Date();
      const shortDate = (
        /** @type {Date} */ date,
        /** @type {undefined} */ locale,
      ) => {
        return date.toLocaleString(locale, { day: "numeric", month: "short" });
      };
      // return formatter.format(new Date());
      return `${shortDate(date)}`;
    },
  ],
});

export const hoursLabel = Variable("", {
  poll: [
    1000,
    function () {
      const date = new Date();
      const hour = (
        /** @type {Date} */ date,
        /** @type {undefined} */ locale,
      ) => {
        return date.toLocaleString(locale, { hour: "2-digit" });
      };
      // return formatter.format(new Date());
      return `${hour(date)}`;
    },
  ],
});

export const minutesLabel = Variable("", {
  poll: [
    1000,
    function () {
      const date = new Date();
      const minute = (
        /** @type {Date} */ date,
        /** @type {undefined} */ locale,
      ) => {
        return date.toLocaleString(locale, { minute: "2-digit" });
      };
      // return formatter.format(new Date());
      return `${minute(date)}`;
    },
  ],
});
