return {
  {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function(_, opts)
      require("solarized").setup(opts)

      vim.opt.termguicolors = true
      vim.cmd.colorscheme("solarized")
      vim.o.background = "dark"
    end,
  }
--  {
--    'folke/tokyonight.nvim',
--    lazy = false,
--    priority = 1000,
--    config = function()
--      require('tokyonight').setup {
--        style = 'night',
--        on_colors = function(colors) end,
--        on_highlights = function(highlights, colors) end,
--      }
--      vim.cmd [[colorscheme tokyonight]]
--    end,
--  },
}
