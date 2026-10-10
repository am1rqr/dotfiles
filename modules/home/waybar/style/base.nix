{
  base = ''
    * {
      font-family: "JetBrainsMono Nerd Font", "Symbols Nerd Font Mono", "Symbols Nerd Font", "Font Awesome 6 Free", "Material Design Icons", "Material Icons", monospace;
      font-size: 13px;
      font-weight: 500;
      min-height: 0;
    }

    window#waybar {
      background: transparent;
      color: @fg0;
      border: none;
    }

    tooltip {
      background: @bg1;
      color: @fg0;
      border: 1px solid @blue;
      border-radius: 10px;
    }

    tooltip label {
      padding: 4px 8px;
    }
  '';
}
