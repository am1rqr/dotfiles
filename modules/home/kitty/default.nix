{ pkgs, ... }:

let
  colors = import ./colors.nix;
in
{
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };

    settings = {
      cursor_shape = "beam";
      cursor_blink_interval = 0;

      scrollback_lines = 10000;
      enable_audio_bell = false;
      window_padding_width = 10;
      confirm_os_window_close = 0;

      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";

      background_opacity = "0.85";
      dynamic_background_opacity = true;
    } // colors;
  };
}
