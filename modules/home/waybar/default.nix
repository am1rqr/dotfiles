{ config, lib, pkgs, ... }:

let
  # Layout
  layout = import ./layout.nix;
  
  # Modules
  workspaces = import ./modules/workspaces.nix;
  window = import ./modules/window.nix;
  clock = import ./modules/clock.nix;
  cpu = import ./modules/cpu.nix;
  memory = import ./modules/memory.nix;
  battery = import ./modules/battery.nix;
  backlight = import ./modules/backlight.nix;
  language = import ./modules/language.nix pkgs;
  network = import ./modules/network.nix;
  pulseaudio = import ./modules/pulseaudio.nix;
  power = import ./modules/power.nix;

  # Styles
  colors = import ./style/colors.nix;
  base = import ./style/base.nix;
  workspacesStyle = import ./style/workspaces.nix;
  modulesStyle = import ./style/modules.nix;
in
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    
    settings = {
      mainBar = lib.mkMerge [
        layout.layout
        workspaces
        window
        clock
        cpu
        memory
        battery
        backlight
        language
        network
        pulseaudio
        power
      ];
    };
    
    style = colors.colors + base.base + workspacesStyle.workspaces + modulesStyle.modules;
  };
}
