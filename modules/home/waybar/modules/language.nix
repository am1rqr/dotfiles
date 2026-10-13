pkgs:
let
  layout = pkgs.writeShellScript "waybar-layout" ''
    print() {
      case "$(/run/current-system/sw/bin/hyprctl devices -j | ${pkgs.jq}/bin/jq -r '.keyboards[] | select(.main) | .active_keymap')" in
        Russian) echo "<span foreground='#fab387' weight='bold'>RU</span>" ;;
        *) echo "<span foreground='#a6e3a1' weight='bold'>EN</span>" ;;
      esac
    }
    print
    ${pkgs.socat}/bin/socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
      case "$line" in
        activelayout*) print ;;
      esac
    done
  '';
in
{
  "custom/language" = {
    exec = "${layout}";
    tooltip = false;
  };
}
