return {
  {
    "AstroNvim/astroui",
    opts = {
      colorscheme = "tokyonight",
    },
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      style = "night",
      transparent = true,
      terminal_colors = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_highlights = function(hl, c)
        hl.NormalFloat = { bg = "NONE" }
        hl.FloatBorder = { fg = c.blue0, bg = "NONE" }
        hl.TelescopeNormal = { bg = "NONE" }
        hl.TelescopeBorder = { fg = c.blue0, bg = "NONE" }
        hl.TelescopePromptNormal = { bg = "NONE" }
        hl.TelescopePromptBorder = { fg = c.blue0, bg = "NONE" }
        hl.NeoTreeNormal = { bg = "NONE" }
        hl.NeoTreeNormalNC = { bg = "NONE" }
        hl.NeoTreeEndOfBuffer = { bg = "NONE" }
        hl.WhichKeyFloat = { bg = "NONE" }
      end,
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    opts = {
      defaults = {
        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "__pycache__",
          "*.pyc",
          ".venv",
          "venv",
        },
      },
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },
  {
    "numToStr/Comment.nvim",
    opts = {},
    lazy = false,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
}
