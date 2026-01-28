return {
  -- Use vitesse
  {
    "https://codeberg.org/pdewey/vitesse-nvim",
    priority = 1000,
  },
  {
    "binhtran432k/dracula.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        float = "transparent",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
    },
  },
}
