{ pkgs, lib, ... }:

let
  terminal = "kitty";
  inherit (lib) getExe;
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = getExe pkgs.${terminal};

    plugins = with pkgs; [
      rofi-emoji
      rofi-games
    ];

    extraConfig = import ./config.nix;
    theme = ./theme.rasi;
  };

  xdg.configFile."rofi/launchers" = {
    source = ./launchers;
    recursive = true;
  };

  xdg.configFile."rofi/colors" = {
    source = ./colors;
    recursive = true;
  };
}
