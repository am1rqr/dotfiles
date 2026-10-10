let icons = import ../icons.nix; in
{
  backlight = {
    format = "{icon} {percent}%";
    format-icons = [ icons.moon icons.sun_half icons.sun ];
    on-scroll-up = "brightnessctl -e4 -n2 set 5%+";
    on-scroll-down = "brightnessctl -e4 -n2 set 5%-";
    tooltip = false;
  };
}
