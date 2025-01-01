return {
  "folke/tokyonight.nvim",
  lazy = false,
  opts = function()
    local is_transparent = false
    local theme_style = "moon"
    return {
      style = theme_style,
      transparent = is_transparent,
      styles = {
        floats = "transparent",
        sidebars = "transparent",
        comments = { italic = false },
        keywords = { italic = false },
        functions = { italic = false },
        variables = { italic = false },
      },
    }
  end,
}
