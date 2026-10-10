let icons = import ../icons.nix; in
{
  "custom/power" = {
    format = icons.power;
    tooltip = true;
    tooltip-format = "Power menu";
    on-click = "wlogout -b 5 -T 380 -B 380 -L 80 -R 80";
  };
}
