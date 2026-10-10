# AstroNvim Configuration

A lightweight AstroNvim setup: quick edits, minimal RAM, and a fully
transparent background (the kitty background shows through). LSP servers start
only when a code file is actually opened, so nothing idles in memory.

## Features

### Language servers (LSP)
Started lazily, based on the type of the opened file:
- **Python**: Pyright (`diagnosticMode = openFilesOnly`, analyzes open files only, not the whole project)
- **TypeScript/JavaScript**: ts_ls

Inlay hints and codelens are off for a clean look; semantic tokens are on.

### Formatting (conform.nvim, no persistent servers)
- **Python**: ruff
- **JS/TS/React, CSS, HTML, JSON, YAML, Markdown**: prettier
- **Lua**: stylua

### Linting
- **Python**: ruff

### Syntax highlighting
Treesitter for all languages and config formats (python, js/ts, tsx, css, html,
json, lua, markdown, **nix, yaml, toml, bash**), with tag auto-closing for
HTML/JSX/TSX.

### Appearance
- **tokyonight (night)** theme, fully transparent: editor, statusline,
  neo-tree, telescope and popups all show the kitty background.
- Transparency and background color come from kitty
  (`modules/home/kitty/`: `background_opacity`, palette in `colors.nix`).

### Plugins
- **neo-tree**: file explorer (opens on start)
- **telescope**: fuzzy finder for files, text and buffers
- **toggleterm** (from AstroNvim): built-in terminal
- **lazygit**: Git integration
- **gitsigns**: Git change markers
- **nvim-surround**: edit surrounding characters
- **flash.nvim**: fast in-file navigation
- **trouble.nvim**: diagnostics list
- **todo-comments**: highlight TODO, FIXME, etc.

## Keybindings

### General
- `<Space>`: leader key
- `<leader>w`: save file
- `<leader>q`: close window
- `jk`: leave insert mode
- `<Esc>`: clear search highlight

### File explorer
- `<leader>e`: toggle Neo-tree

### Search (Telescope)
- `<leader>ff`: find files
- `<leader>fg`: grep file contents
- `<leader>fb`: buffer list
- `<leader>fh`: help tags
- `<leader>fr`: recent files

### Git
- `<leader>gg`: open LazyGit

### Terminal (toggleterm)
- `<C-'>`: toggle terminal (like VS Code)
- `<leader>tf`: floating terminal
- `<leader>th`: horizontal terminal
- `<leader>tv`: vertical terminal
- In the terminal: `<C-\><C-n>` leaves to normal mode

### Navigation
- `<C-h/j/k/l>`: move between windows
- `<S-h>`: previous buffer
- `<S-l>`: next buffer
- `<leader>bd`: close buffer

### LSP
- `<leader>ca`: code actions
- `<leader>rn`: rename symbol
- `gd`: go to definition
- `gr`: show references
- `gi`: go to implementation
- `K`: show documentation
- `[d` / `]d`: previous/next diagnostic
- `<leader>d`: show line diagnostics

### Trouble (diagnostics)
- `<leader>xx`: all problems
- `<leader>xX`: problems in the current buffer
- `<leader>cs`: symbols
- `<leader>cl`: LSP definitions/references

### Visual mode
- `<` / `>`: outdent/indent (keeps the selection)
- `J` / `K`: move lines down/up

### Flash
- `s`: jump to a character
- `S`: jump to a Treesitter node

## Applying the configuration

1. Make sure all changes are saved.
2. Rebuild NixOS (Home Manager is a NixOS module, there is no separate
   `home-manager switch`):
   ```bash
   sudo nixos-rebuild switch --flake ~/dotfiles#nixos
   ```
3. Open Neovim. On first start lazy.nvim installs all plugins by itself.
4. Restart Neovim once the installation finishes.

LSP servers are installed through Nix packages during the rebuild.

## Tips

- **Python**: ruff formats and fixes code on save.
- **React/TypeScript**: prettier formats on save; ts_ls provides completion, go-to-definition and diagnostics.
- **Transparency**: to make the background less transparent, raise `background_opacity` in `modules/home/kitty/default.nix`.

## Structure

```
lua/
├── plugins/
│   ├── autocmds.lua      # autocommands
│   ├── completion.lua    # completion
│   ├── formatting.lua    # formatters
│   ├── git.lua           # Git integration
│   ├── keymaps.lua       # keybindings
│   ├── linting.lua       # linters
│   ├── lsp.lua           # LSP configuration
│   ├── neo-tree.lua      # file explorer
│   ├── options.lua       # editor options
│   ├── treesitter.lua    # syntax highlighting
│   ├── ui.lua            # UI plugins
│   └── user.lua          # extra plugins
```
