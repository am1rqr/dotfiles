{ config, pkgs, lib, ... }:

let
  monitors = import ./monitors.nix;
  variables = import ./variables.nix;
  env = import ./env.nix;
  appearance = import ./appearance.nix;
  animations = import ./animations.nix;
  layouts = import ./layouts.nix;
  input = import ./input.nix;
  gestures = import ./gestures.nix;
  binds = import ./binds.nix;
  windowrules = import ./windowrules.nix;
  execOnce = import ./exec-once.nix { inherit config; };
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = lib.mkMerge [
      monitors
      variables
      env
      appearance
      animations
      layouts
      input
      gestures
      binds
      windowrules
      execOnce
    ];
  };

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}

