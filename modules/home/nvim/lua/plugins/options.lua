return {
  {
    "AstroNvim/AstroNvim",
    opts = function(_, opts)
      local options = {
        opt = {
          relativenumber = true,
          number = true,
          spell = false,
          signcolumn = "yes",
          wrap = false,
          scrolloff = 8,
          sidescrolloff = 8,
          expandtab = true,
          shiftwidth = 2,
          tabstop = 2,
          softtabstop = 2,
          smartindent = true,
          breakindent = true,
          undofile = true,
          swapfile = false,
          backup = false,
          hlsearch = true,
          incsearch = true,
          ignorecase = true,
          smartcase = true,
          termguicolors = true,
          updatetime = 250,
          timeoutlen = 300,
          completeopt = "menuone,noselect",
          cursorline = true,
          splitbelow = true,
          splitright = true,
        },
        g = {
          mapleader = " ",
          maplocalleader = ",",
        },
      }

      if not opts.options then opts.options = {} end
      opts.options = vim.tbl_deep_extend("force", opts.options, options)

      return opts
    end,
  },
}
