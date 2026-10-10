{ config, pkgs, username, ... }:

{
  imports = [
    ./hyprland/default.nix
    ./waybar/default.nix
    ./wlogout/default.nix
    ./hyprlock/default.nix
    ./rofi/default.nix
    ./kitty/default.nix
    ./hyprland/wallpaper.nix
    ./ncalayer/default.nix
    ./qimgv/default.nix
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = false;
    vimAlias = true;
    viAlias = true;
  };

  programs.zed-editor = {
    enable = true;
    userSettings = {
      theme = "BMW Dusk";
      icon_theme = "Zed (Default)";
      vim_mode = false;

      # Nix owns the binary — never let Zed self-update against the store.
      auto_update = false;
      # Empty window on launch = instant startup; open files/projects on demand.
      restore_on_startup = "none";
      autosave = {
        after_delay = {
          milliseconds = 1000;
        };
      };

      git = {
        git_gutter = "tracked_files";
        inline_blame = {
          enabled = false;
        };
      };
      current_line_highlight = "line";
      indent_guides = {
        enabled = true;
      };
      seed_search_query_from_cursor = "selection";

      session = {
        trust_all_worktrees = true;
      };
      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      # No built-in AI — Claude Code in the terminal is the assistant.
      features = {
        edit_prediction_provider = "none";
      };
      agent = {
        enabled = false;
      };

      buffer_font_family = "JetBrainsMono Nerd Font";
      buffer_font_size = 16;
      buffer_font_weight = 500;
      ui_font_family = "JetBrainsMono Nerd Font";
      ui_font_size = 15;
      tab_size = 4;
      soft_wrap = "editor_width";
      cursor_blink = false;
      relative_line_numbers = false;

      # Read-mostly: no reformat on the rare save, no LSP inlay noise.
      format_on_save = "off";
      inlay_hints = {
        enabled = false;
      };

      # Keep only ruff (native, exits instantly). Dropping basedpyright (Node)
      # removes the multi-second graceful-shutdown wait on quit.
      languages = {
        Python = {
          language_servers = [ "ruff" "!..." ];
        };
      };

      scrollbar = {
        show = "auto";
      };
      minimap = {
        show = "never";
      };
      tab_bar = {
        show = true;
      };
      project_panel = {
        dock = "left";
      };
      terminal = {
        font_family = "JetBrainsMono Nerd Font";
        font_size = 14;
        blinking = "off";
        copy_on_select = true;
      };
    };

    # Zed's image viewer handles png/jpg/gif/bmp/ico/tiff/webp natively, but
    # opens svg as XML and rejects avif — zed-preview rasterizes those to png.
    userTasks = [
      {
        label = "Preview file";
        command = "zed-preview";
        args = [ "$ZED_FILE" ];
        use_new_terminal = false;
        allow_concurrent_runs = true;
        reveal = "never";
        hide = "on_success";
      }
    ];

    userKeymaps = [
      {
        context = "Workspace";
        bindings = {
          "ctrl-alt-v" = [ "task::Spawn" { task_name = "Preview file"; } ];
        };
      }
    ];
  };

  home.file.".config/zed/themes/bmw-dusk.json".source = ./zed/themes/bmw-dusk.json;

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  gtk = {
    enable = true;
    theme = {
      name = "Nordic-darker";
      package = pkgs.nordic;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 28;
    gtk.enable = true;
    x11.enable = true;
    hyprcursor.enable = true;
  };

  home.sessionPath = [ "$HOME/.local/bin" "$HOME/.npm-global/bin" ];
  home.sessionVariables = {
    EDITOR = "zeditor --wait";
    VISUAL = "zeditor --wait";
  };
  programs.bash = {
    enable = true;
    shellAliases = {
      zed = "zeditor";
      zq = "pkill -9 -f libexec/zed";
    };
    initExtra = ''
      export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"
      if [ "$TERM" = "xterm-kitty" ]; then
        alias ssh="kitten ssh"
      fi
    '';
  };

  home.packages = with pkgs; [
    (writeShellApplication {
      name = "zed-preview";
      runtimeInputs = [ resvg libavif zed-editor ];
      text = ''
        dir="''${XDG_RUNTIME_DIR:-/tmp}/zed-preview"
        mkdir -p "$dir"
        png="$dir/$(basename "$1").png"
        case "$1" in
          *.svg|*.svgz) resvg --width 1200 "$1" "$png" ;;
          *.avif) avifdec "$1" "$png" ;;
          *) png="$1" ;;
        esac
        zeditor "$png"
      '';
    })

    (writeShellApplication {
      name = "pgadmin4-launch";
      runtimeInputs = [ pgadmin4-desktopmode curl xdg-utils ];
      text = ''
        url="http://127.0.0.1:5050"
        if ! curl -s -o /dev/null "$url"; then
          setsid pgadmin4 >/tmp/pgadmin4.log 2>&1 < /dev/null &
          for _ in $(seq 1 30); do
            curl -s -o /dev/null "$url" && break
            sleep 0.5
          done
        fi
        xdg-open "$url"
      '';
    })

    home-manager
    swww
    brightnessctl
    playerctl
    git
    nodejs
    ripgrep
    fd
    wl-clipboard
    tree-sitter
    lazygit
    bottom
    jq
    obs-studio
    pgadmin4-desktopmode
    qdirstat
    rustdesk-flutter

    pyright
    python312Packages.ruff
    python312Packages.black

    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    tailwindcss-language-server
    nodePackages.eslint_d
    nodePackages.prettier

    lua-language-server
    stylua
  ];

  home.file.".config/nvim" = {
    source = ./nvim;
    recursive = true;
  };

  home.file.".config/networkmanager-dmenu/config.ini".text = ''
    [dmenu]
    dmenu_command = rofi -dmenu -i -p Wi-Fi
    rofi_highlight = True
    compact = False

    [editor]
    gui_if_available = True
  '';

  # pgadmin4-desktopmode has no native window on NixOS — it's a local Flask
  # server you open in a browser. pgadmin4-launch starts it and opens the URL.
  xdg.desktopEntries.pgadmin4 = {
    name = "pgAdmin 4";
    comment = "Administration and development platform for PostgreSQL";
    exec = "pgadmin4-launch";
    icon = "${pkgs.pgadmin4-desktopmode}/lib/python3.13/site-packages/pgadmin4/pgadmin/static/img/logo-256.png";
    terminal = false;
    categories = [ "Development" "Database" ];
  };

  programs.home-manager.enable = true;
}
