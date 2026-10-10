let icons = import ../icons.nix; in
{
  battery = {
    states = {
      warning = 30;
      critical = 15;
    };
    format = "{icon} {capacity}%";
    format-charging = "${icons.bat_charging} {capacity}%";
    format-plugged = "${icons.bat_plugged} {capacity}%";
    format-alt = "{icon} {time}";
    format-icons = [ icons.bat_0 icons.bat_1 icons.bat_2 icons.bat_3 icons.bat_4 ];
    tooltip-format = "{timeTo}, {capacity}%";
  };
}
