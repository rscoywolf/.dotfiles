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
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ignore_install = { "help" }

      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "dockerfile",
          "git_config",
          "jsdoc",
          "make",
          "toml",
          "vimdoc",
        })
      end
    end,
  },
  {
    "xiyaowong/transparent.nvim",
  },
}
