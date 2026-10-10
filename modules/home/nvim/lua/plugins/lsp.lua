return {
  {
    "AstroNvim/astrolsp",
    opts = {
      features = {
        codelens = false,
        inlay_hints = false,
        semantic_tokens = true,
      },
      formatting = {
        format_on_save = {
          enabled = false,
        },
      },
      servers = {
        "pyright",
        "ts_ls",
      },
      config = {
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
              },
            },
          },
        },
      },
    },
  },
}
