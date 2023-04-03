return {
  -- add vimtex
  {
    "lervag/vimtex",
    config = function()
      vim.g.vimtex_view_method = "zathura"
    end,
  },
  -- add vim-surround
  {
    "tpope/vim-surround",
  },
  -- add syntax highlighting for fish config
  {
    "khaveesh/vim-fish-syntax",
  },
}
