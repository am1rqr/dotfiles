{
  general = {
    gaps_in = 5;
    gaps_out = 20;
    border_size = 2;
    "col.active_border" = "rgba(6395daee) rgba(add1fdee) 45deg";
    "col.inactive_border" = "rgba(2e3e4faa)";
    resize_on_border = false;
    allow_tearing = false;
    layout = "dwindle";
  };

  decoration = {
    rounding = 10;
    rounding_power = 2;
    active_opacity = 1.0;
    inactive_opacity = 1.0;

    shadow = {
      enabled = true;
      range = 4;
      render_power = 3;
      color = "rgba(1a1a1aee)";
    };

    blur = {
      enabled = true;
      size = 3;
      passes = 1;
      vibrancy = 0.1696;
    };
  };

  misc = {
    force_default_wallpaper = -1;
    disable_hyprland_logo = false;
  };
}

