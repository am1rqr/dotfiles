pkgs:
let
  icons = import ../icons.nix;
  hint = pkgs.writeShellScript "waybar-hint" ''
    s=$(cat "$XDG_RUNTIME_DIR/exam-hint-state" 2>/dev/null)
    [ -z "$s" ] && s=$(${pkgs.bluez}/bin/bluetoothctl devices Connected 2>/dev/null | wc -l)
    if [ "$1" = left ]; then out=""; else out="$s"; fi
    echo "$out"
  '';
  click = pkgs.writeShellScript "waybar-bt-click" ''
    if [ -e "$XDG_RUNTIME_DIR/exam-hint-showing" ]; then
      touch "$XDG_RUNTIME_DIR/exam-hint-skip"
    else
      exec blueman-manager
    fi
  '';
in
{
  bluetooth = {
    format = "${icons.bluetooth}";
    format-on = "${icons.bluetooth}";
    format-off = "${icons.bluetooth_off}";
    format-disabled = "${icons.bluetooth_off}";
    format-connected = "${icons.bluetooth}";
    tooltip-format = "{controller_alias}\n{num_connections} connected";
    tooltip-format-connected = "{controller_alias}\n{device_enumerate}";
    tooltip-format-enumerate-connected = "{device_alias}";
    tooltip-format-enumerate-connected-battery = "{device_alias} {device_battery_percentage}%";
    on-click = "${click}";
    on-click-right = "bluetoothctl power toggle";
  };
  "custom/hintl" = {
    exec = "${hint} left";
    signal = 8;
    tooltip = false;
  };

  "custom/hint" = {
    exec = "${hint} right";
    interval = 3;
    signal = 8;
    tooltip = false;
  };

  "group/bt" = {
    orientation = "horizontal";
    modules = [ "custom/hintl" "bluetooth" "custom/hint" ];
  };
}
