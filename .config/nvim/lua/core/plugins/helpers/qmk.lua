return {
  "codethread/qmk.nvim",
  event = "VeryLazy",
  config = function()
    local status_ok, qmk = pcall(require, "qmk")
    if not status_ok then
      return
    end

    local conf = {
      name = "LAYOUT",
      layout = {
        "x x x x x x _ _ _ x x x x x x",
        "x x x x x x _ _ _ x x x x x x",
        "x x x x x x _ _ _ x x x x x x",
        "x x x x x x x _ x x x x x x x",
        "_ _ x x x x x _ x x x x x _ _",
      },
      comment_preview = {
        keymap_overrides = {
          -- default keys
          KC_BSPC = "󰁮",
          KC_DEL = "󰹾",
          KC_LSFT = "󰘶",
          KC_RSFT = "󰘶",
          KC_TAB = "󰌒",
          -- arrow keys
          KC_LEFT = "",
          KC_DOWN = "",
          KC_UP = "",
          KC_RIGHT = "",
          -- mod keys
          KC_LCTL = "󰘴",
          KC_RCTL = "󰘴",
          KC_LALT = "󰘵",
          KC_RALT = "󰘵",
          KC_LGUI = "󰘳/",
          KC_RGUI = "󰘳/",
          -- media keys
          KC_MPLY = "",
          KC_VOLU = "",
          KC_VOLD = "",
          KC_MPRV = "󰒮",
          KC_MNXT = "󰒭",
          -- layers
          KC_LOWER = "󱞡",
          KC_RAISE = "󱞿",
          KC_QWERTY = "",
          KC_LINUX = "",
        },
      },
    }
    qmk.setup(conf)
  end,
}
