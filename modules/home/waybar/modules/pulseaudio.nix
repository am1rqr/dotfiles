let icons = import ../icons.nix; in
{
  pulseaudio = {
    format = "{icon} {volume}%";
    format-muted = "${icons.vol_low} ";
    format-icons = {
      headphone = icons.headphone;
      hands-free = icons.mic;
      headset = icons.headphone;
      phone = icons.phone;
      portable = icons.phone;
      car = icons.car;
      default = [ icons.vol_low icons.vol_med icons.vol_high ];
    };
    on-click = "pavucontrol";
    scroll-step = 5;
  };
}
