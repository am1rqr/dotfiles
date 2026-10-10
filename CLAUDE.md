# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

Apply all changes (system packages, services, and home-manager user config):
```
sudo nixos-rebuild switch --flake /home/user/dotfiles#nixos
```
or via `nh` (flake path preset, shows a package diff, leaves no `result` symlink):
```
nh os switch        # nh os boot — for changes that require a reboot
```

Generations are cleaned weekly by `programs.nh.clean` (keeps the last 20 plus
everything from the past 14 days); `nix.settings.min-free`/`max-free` trigger GC
during builds when the disk runs low.

Check for syntax / evaluation errors without applying:
```
nix flake check
```

Update pinned inputs (nixpkgs, home-manager):
```
nix flake update
```

**Note:** Home Manager is wired into NixOS as a module (see `flake.nix`), not as a
standalone flake output. A single `nixos-rebuild switch` rebuilds both system and
user configuration — `home-manager switch` will fail with "flake does not provide
attribute ... homeConfigurations".

## Architecture

**NixOS Flakes** + **Home Manager as a NixOS module**. A single host `nixos`
defined in `flake.nix`; user config for `user` is imported into the system
closure via `home-manager.nixosModules.home-manager`.

### Entry Points

- `flake.nix` — pins nixpkgs (unstable) + home-manager; composes the `nixos`
  host by combining `hosts/nixos/configuration.nix` with the home-manager
  module that imports `modules/home/home.nix`.
- `hosts/nixos/configuration.nix` — system-level: bootloader, locale
  (en_US + kk_KZ), networking, Hyprland, SDDM, pipewire, Docker (rootless),
  VirtualBox, system packages, fonts, `nix-ld`.
- `modules/home/home.nix` — Home Manager entry point: user packages, bash
  config (aliases, `initExtra`), and `home.file` symlinks that copy config
  trees into `~/.config`.

### Config delivery pattern

Home Manager copies/symlinks config directories declaratively. For example,
`modules/home/nvim/` → `~/.config/nvim` via `home.file.".config/nvim"` with
`recursive = true`. To add a new tool's config, either:
- Add a module under `modules/home/<tool>/` and import it from
  `modules/home/home.nix`, or
- Declare `home.file` directly in `home.nix` for a one-off config tree.

### Module layout

```
modules/home/
├── home.nix          # User packages, bash (aliases + initExtra), home.file symlinks
├── hyprland/         # Split into binds, animations, rules, monitors, variables, etc.
├── waybar/           # config.nix + CSS modules (base, colors, workspaces, modules)
├── rofi/             # Launcher variants, themes, shared assets
└── nvim/             # AstroNvim base + lua/plugins/ overrides
```

### Hyprland keybinds

Defined in `modules/home/hyprland/binds.nix`. `movetoworkspace` switches focus
to the target workspace; `movetoworkspacesilent` moves the window without
following. Prefer `movetoworkspacesilent` for Win+Shift+N-style binds unless
follow-behavior is intentional.

### Neovim

Uses **AstroNvim** as the base distribution. Per-plugin overrides live in
`modules/home/nvim/lua/plugins/`. Configured stack:
- LSP: pyright, ts_ls, tailwindcss, html, cssls, jsonls, eslint
- Formatters: ruff (Python), prettier (JS/TS/HTML/CSS), stylua (Lua)
- Linters: ruff, eslint_d

### Dependency pinning

`flake.lock` pins exact commits for nixpkgs and home-manager. To bump, run
`nix flake update` then rebuild.
