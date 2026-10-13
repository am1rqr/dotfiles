pkgs:
let
  layout = pkgs.writeShellScript "waybar-layout" ''
    case "$(/run/current-system/sw/bin/hyprctl devices -j | ${pkgs.jq}/bin/jq -r '.keyboards[] | select(.main) | .active_keymap')" in
      Russian) echo "<span foreground='#fab387' weight='bold'>RU</span>" ;;
      *) echo "<span foreground='#a6e3a1' weight='bold'>EN</span>" ;;
    esac
  '';
in
{
  "custom/language" = {
    exec = "${layout}";
    interval = 1;
    tooltip = false;
  };
}
