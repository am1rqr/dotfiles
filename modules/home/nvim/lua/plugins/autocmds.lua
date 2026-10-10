return {
  {
    "AstroNvim/AstroNvim",
    opts = function(_, opts)
      local function clear_bg(group)
        local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
        hl.bg = nil
        hl.ctermbg = nil
        vim.api.nvim_set_hl(0, group, hl)
      end

      local transparent_groups = {
        "Normal",
        "NormalNC",
        "NormalFloat",
        "FloatBorder",
        "SignColumn",
        "LineNr",
        "CursorLineNr",
        "EndOfBuffer",
        "FoldColumn",
        "MsgArea",
        "TelescopeNormal",
        "TelescopeBorder",
        "TelescopePromptNormal",
        "TelescopePromptBorder",
        "NeoTreeNormal",
        "NeoTreeNormalNC",
        "NeoTreeEndOfBuffer",
        "WhichKeyFloat",
      }

      local autocmds = {
        neotree_start = {
          {
            event = "VimEnter",
            desc = "Open Neo-Tree on startup",
            callback = function()
              if vim.fn.argc() == 0 then
                vim.cmd("Neotree show")
              end
            end,
          },
        },
        force_transparent = {
          {
            event = "ColorScheme",
            desc = "Force transparent background regardless of theme",
            callback = function()
              for _, g in ipairs(transparent_groups) do
                clear_bg(g)
              end
            end,
          },
        },
        term_ui = {
          {
            event = "TermOpen",
            desc = "Clean terminal UI",
            callback = function()
              vim.opt_local.number = false
              vim.opt_local.relativenumber = false
              vim.opt_local.signcolumn = "no"
              vim.opt_local.spell = false
              vim.opt_local.cursorline = false
              vim.cmd.startinsert()
            end,
          },
          {
            event = { "BufEnter", "WinEnter" },
            desc = "Enter insert mode when focusing a terminal",
            callback = function(args)
              if vim.bo[args.buf].buftype == "terminal" then
                vim.cmd.startinsert()
              end
            end,
          },
        },
        auto_root = {
          {
            event = { "BufReadPost", "BufEnter" },
            desc = "Set cwd to project root so neo-tree opens at the project",
            callback = function(args)
              if vim.bo[args.buf].buftype ~= "" then return end
              local path = vim.api.nvim_buf_get_name(args.buf)
              if path == "" then return end
              if vim.fn.isdirectory(path) == 0 then
                path = vim.fs.dirname(path)
              end
              local root = vim.fs.root(path, {
                ".git",
                "flake.nix",
                "pyproject.toml",
                "package.json",
                "Makefile",
              })
              if root and root ~= vim.uv.cwd() then
                vim.cmd.cd(vim.fn.fnameescape(root))
              end
            end,
          },
        },
      }

      if not opts.autocmds then opts.autocmds = {} end
      opts.autocmds = vim.tbl_deep_extend("force", opts.autocmds, autocmds)

      return opts
    end,
  },
}
