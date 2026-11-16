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
      {
        context = "Editor && extension == md";
        bindings = {
          "ctrl-shift-v" = "markdown::OpenPreviewToTheSide";
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
    gtk3.extraCss = ''
      window.thunar {
        background-color: rgba(26, 36, 48, 0.8);
      }
      window.thunar .background:not(:selected),
      window.thunar .view:not(:selected),
      window.thunar .sidebar,
      window.thunar toolbar,
      window.thunar menubar,
      window.thunar statusbar,
      window.thunar paned,
      window.thunar scrolledwindow,
      window.thunar viewport,
      window.thunar treeview.view,
      window.thunar iconview,
      window.thunar box,
      window.thunar grid {
        background-color: transparent;
      }
    '';
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
    btop
    jq
    obs-studio
    kdePackages.kdenlive
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

  home.file.".local/bin/exam-hint" = {
    executable = true;
    text = ''
      #!/usr/bin/env python3
      import subprocess, tempfile, os, json, urllib.request, base64, re, sys, fcntl

      import time, traceback

      lock = open(os.path.join(os.environ['XDG_RUNTIME_DIR'], 'exam-hint.lock'), 'w')
      try:
          fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
      except BlockingIOError:
          sys.exit(0)
      for name in ('exam-hint-showing', 'exam-hint-skip'):
          try:
              os.remove(os.path.join(os.environ['XDG_RUNTIME_DIR'], name))
          except FileNotFoundError:
              pass

      def log(msg):
          with open('/tmp/exam-hint.log', 'a') as f:
              f.write(time.strftime('%H:%M:%S ') + msg + '\n')

      open('/tmp/exam-hint.log', 'w').close()
      log('start')

      state_file = os.path.join(os.environ['XDG_RUNTIME_DIR'], 'exam-hint-state')

      def show(text):
          with open(state_file, 'w') as f:
              f.write(text)
          subprocess.run(['pkill', '-RTMIN+8', 'waybar'])

      def flash(text, secs=3):
          show(text)
          time.sleep(secs)
          show("")

      show('L')

      key_file = os.path.expanduser('~/.config/exam-hint/key')
      try:
          api_key = open(key_file).read().strip()
      except FileNotFoundError:
          log('key file missing: ' + key_file)
          flash('?')
          sys.exit(1)

      tmp = tempfile.mktemp(suffix='.png')
      try:
          grim = subprocess.run(['grim', tmp], capture_output=True, text=True)
          log(f'grim rc={grim.returncode} stderr={grim.stderr.strip()!r}')
          with open(tmp, 'rb') as f:
              raw = f.read()
      except Exception:
          log('screenshot failed:\n' + traceback.format_exc())
          flash('!')
          sys.exit(1)
      keep = '/tmp/exam-hint-last.png'
      os.replace(tmp, keep)
      log(f'screenshot {len(raw)} bytes, saved to {keep}')
      img_b64 = base64.b64encode(raw).decode()

      url = (
          'https://generativelanguage.googleapis.com/v1beta/'
          f'models/gemini-flash-latest:generateContent?key={api_key}'
      )
      body = {
          "contents": [{
              "parts": [
                  {
                      "text": (
                          "This is a screenshot of a Moodle quiz page. "
                          "There may be multiple questions visible (Question 5, Question 6, etc.). "
                          "For each visible question marked 'Not yet answered', "
                          "determine ALL correct answers (some questions say 'Select all that apply'). "
                          "Reply with ONLY lines in this exact format: "
                          "'Q5: c e' or 'Q6: b' or 'Q7: a c d e' "
                          "(question number, colon, space-separated correct option letters a-e). "
                          "List only unanswered questions, in order. No other text."
                      )
                  },
                  {"inline_data": {"mime_type": "image/png", "data": img_b64}}
              ]
          }],
          "generationConfig": {"maxOutputTokens": 2000, "temperature": 0}
      }

      try:
          req = urllib.request.Request(
              url,
              data=json.dumps(body).encode(),
              headers={'Content-Type': 'application/json'}
          )
          t0 = time.time()
          with urllib.request.urlopen(req, timeout=40) as resp:
              data = json.loads(resp.read())
              log(f'http {resp.status} in {time.time() - t0:.1f}s')
          candidate = data['candidates'][0]
          parts = candidate.get('content', {}).get('parts', [])
          text = "".join(p.get('text', "") for p in parts)
          usage = data.get('usageMetadata', {})
          log(f'model={data.get("modelVersion")} finishReason={candidate.get("finishReason")} '
              f'tokens(prompt={usage.get("promptTokenCount")} thoughts={usage.get("thoughtsTokenCount")} '
              f'out={usage.get("candidatesTokenCount")})')
          log(f'response text: {text!r}')
          lines = re.findall(r'Q(\d+):\s*([a-e](?:\s+[a-e])*)', text, re.IGNORECASE)
          letters = ["".join(a.split()) for _, a in lines]
          answers = (letters if len(letters) == 1 else [f'{i}{a}' for i, a in enumerate(letters, 1)]) or ['?']
      except urllib.error.HTTPError as e:
          log(f'http error {e.code}: {e.read().decode(errors="replace")[:500]}')
          answers = ['!']
      except Exception:
          log('request failed:\n' + traceback.format_exc())
          answers = ['!']
      log(f'answers: {answers}')

      showing_file = os.path.join(os.environ['XDG_RUNTIME_DIR'], 'exam-hint-showing')
      skip_file = os.path.join(os.environ['XDG_RUNTIME_DIR'], 'exam-hint-skip')
      open(showing_file, 'w').close()
      for ans in answers:
          if os.path.exists(skip_file):
              os.remove(skip_file)
          show(ans.upper())
          for _ in range(30):
              time.sleep(0.1)
              if os.path.exists(skip_file):
                  os.remove(skip_file)
                  break
      os.remove(showing_file)
      show("")
    '';
  };

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
