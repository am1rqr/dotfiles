{ config, pkgs, ... }:

let
  # hyprlock can't detect at parse-time which monitor is connected, so a wrapper
  # picks the target output at launch: external HDMI-A-1 if present, else the
  # laptop eDP-1. It defines $LOCKMON, then sources the declarative base config
  # whose interactive widgets are pinned to monitor = $LOCKMON.
  lockscreen = pkgs.writeShellScriptBin "lockscreen" ''
    set -eu
    mon="eDP-1"
    if hyprctl monitors -j | jq -e 'any(.[]; .name == "HDMI-A-1")' >/dev/null 2>&1; then
      mon="HDMI-A-1"
    fi
    conf="''${XDG_RUNTIME_DIR:-/tmp}/hyprlock-active.conf"
    printf '$LOCKMON = %s\nsource = %s/hypr/hyprlock.conf\n' \
      "$mon" "''${XDG_CONFIG_HOME:-$HOME/.config}" > "$conf"
    exec hyprlock -c "$conf"
  '';
in
{
  home.packages = [ lockscreen ];

  home.file.".config/hyprlock/avatar.jpg".source = ./avatar.jpg;

  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = true;
        grace = 0;
        ignore_empty_input = true;
      };

      background = [{
        path = "${config.xdg.configHome}/wallpapers/wallpaper-bmw.jpg";
        blur_passes = 3;
        blur_size = 8;
        brightness = 0.7;
        contrast = 0.9;
        vibrancy = 0.17;
      }];

      label = [
        {
          monitor = "$LOCKMON";
          text = "$TIME";
          color = "rgba(193, 219, 241, 1.0)";
          font_size = 72;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 300";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "$LOCKMON";
          text = "cmd[update:60000] date +'%A, %d %B'";
          color = "rgba(193, 219, 241, 0.85)";
          font_size = 20;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 230";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "$LOCKMON";
          text = "Amir";
          color = "rgba(193, 219, 241, 1.0)";
          font_size = 22;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, -30";
          halign = "center";
          valign = "center";
        }
      ];

      image = [{
        monitor = "$LOCKMON";
        path = "${config.xdg.configHome}/hyprlock/avatar.jpg";
        size = 150;
        rounding = 22;
        border_size = 3;
        border_color = "rgba(99, 149, 218, 1.0)";
        position = "0, 90";
        halign = "center";
        valign = "center";
      }];

      input-field = [{
        monitor = "$LOCKMON";
        size = "260, 50";
        outline_thickness = 2;
        rounding = 14;
        outer_color = "rgba(99, 149, 218, 1.0)";
        inner_color = "rgba(46, 62, 79, 0.85)";
        font_color = "rgba(193, 219, 241, 1.0)";
        check_color = "rgba(143, 169, 120, 1.0)";
        fail_color = "rgba(194, 116, 140, 1.0)";
        placeholder_text = "Password...";
        fade_on_empty = false;
        position = "0, -110";
        halign = "center";
        valign = "center";
      }];
    };
  };
}
