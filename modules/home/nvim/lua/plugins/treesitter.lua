return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "python",
        "javascript",
        "typescript",
        "tsx",
        "css",
        "html",
        "json",
        "lua",
        "vim",
        "vimdoc",
        "markdown",
        "markdown_inline",
        "nix",
        "yaml",
        "toml",
        "bash",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },
}
