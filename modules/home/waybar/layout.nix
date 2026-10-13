{
  layout = {
    layer = "top";
    position = "top";
    height = 38;
    spacing = 6;
    margin-top = 2;
    margin-left = 8;
    margin-right = 8;

    modules-left = [
      "hyprland/workspaces"
      "hyprland/window"
    ];

    modules-center = [
      "clock"
    ];

    modules-right = [
      "custom/language"
      "pulseaudio"
      "backlight"
      "network"
      "cpu"
      "memory"
      "battery"
      "custom/power"
    ];
  };
}
