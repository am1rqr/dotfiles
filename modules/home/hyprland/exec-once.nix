{ config }:

{
  exec-once = [
    "uwsm finalize"
    "lockscreen"
    "waybar"
    "swww-daemon"
    "sleep 1 && swww img ${config.xdg.configHome}/wallpapers/wallpaper-bmw.jpg --transition-type none"
  ];
}
