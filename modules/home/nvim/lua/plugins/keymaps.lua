return {
  {
    "AstroNvim/AstroNvim",
    opts = function(_, opts)
      local mappings = {
        n = {
          ["<leader>e"] = { "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" },
          ["<leader>w"] = { "<cmd>w<cr>", desc = "Save" },
          ["<leader>q"] = { "<cmd>q<cr>", desc = "Quit" },

          ["<leader>ff"] = { "<cmd>Telescope find_files<cr>", desc = "Find files" },
          ["<leader>fg"] = { "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
          ["<leader>fb"] = { "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
          ["<leader>fh"] = { "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
          ["<leader>fr"] = { "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },

          ["<leader>gg"] = { "<cmd>LazyGit<cr>", desc = "LazyGit" },

          ["<C-h>"] = { "<C-w>h", desc = "Go to left window" },
          ["<C-j>"] = { "<C-w>j", desc = "Go to lower window" },
          ["<C-k>"] = { "<C-w>k", desc = "Go to upper window" },
          ["<C-l>"] = { "<C-w>l", desc = "Go to right window" },

          ["<C-Up>"] = { "<cmd>resize -2<cr>", desc = "Resize window up" },
          ["<C-Down>"] = { "<cmd>resize +2<cr>", desc = "Resize window down" },
          ["<C-Left>"] = { "<cmd>vertical resize -2<cr>", desc = "Resize window left" },
          ["<C-Right>"] = { "<cmd>vertical resize +2<cr>", desc = "Resize window right" },

          ["<S-h>"] = { "<cmd>bprevious<cr>", desc = "Previous buffer" },
          ["<S-l>"] = { "<cmd>bnext<cr>", desc = "Next buffer" },
          ["<leader>bd"] = { "<cmd>bdelete<cr>", desc = "Delete buffer" },

          ["<leader>ca"] = { vim.lsp.buf.code_action, desc = "Code action" },
          ["<leader>rn"] = { vim.lsp.buf.rename, desc = "Rename" },
          ["gd"] = { vim.lsp.buf.definition, desc = "Go to definition" },
          ["gr"] = { vim.lsp.buf.references, desc = "Go to references" },
          ["gi"] = { vim.lsp.buf.implementation, desc = "Go to implementation" },
          ["K"] = { vim.lsp.buf.hover, desc = "Hover" },

          ["[d"] = { vim.diagnostic.goto_prev, desc = "Previous diagnostic" },
          ["]d"] = { vim.diagnostic.goto_next, desc = "Next diagnostic" },
          ["<leader>d"] = { vim.diagnostic.open_float, desc = "Line diagnostics" },

          ["<Esc>"] = { "<cmd>nohlsearch<cr>", desc = "Clear highlights" },
        },
        v = {
          ["<"] = { "<gv", desc = "Unindent line" },
          [">"] = { ">gv", desc = "Indent line" },
          ["J"] = { ":m '>+1<cr>gv=gv", desc = "Move line down" },
          ["K"] = { ":m '<-2<cr>gv=gv", desc = "Move line up" },
        },
        i = {
          ["jk"] = { "<Esc>", desc = "Exit insert mode" },
        },
      }

      if not opts.mappings then opts.mappings = {} end
      opts.mappings = vim.tbl_deep_extend("force", opts.mappings, mappings)

      return opts
    end,
  },
}
