return {
  "supermaven-inc/supermaven-nvim",
  event = "InsertEnter",
  cmd = {
    "SupermavenUseFree",
    "SupermavenUsePro",
  },
  opts = {
    keymaps = {
      accept_suggestion = "<S-Tab>", -- handled by nvim-cmp / blink.cmp
      accept_word = "<Tab>", -- handled by nvim-cmp / blink.cmp
    },
    ignore_filetypes = { "bigfile", "snacks_input", "snacks_notif" },
    log_level = "info",
    disable_inline_completion = false,
    disable_keymaps = false,
  },
}
