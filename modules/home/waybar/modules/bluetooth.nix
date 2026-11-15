pkgs:
let
  icons = import ../icons.nix;
  hint = pkgs.writeShellScript "waybar-hint" ''
    s=$(cat "$XDG_RUNTIME_DIR/exam-hint-state" 2>/dev/null)
    k=2
    l=$(( (k - ''${#s}) / 2 ))
    if [ "$1" = left ]; then n=$l; out=""; else n=$((k - l - ''${#s})); out="$s"; fi
    for ((i = 0; i < n; i++)); do out+="&#8199;"; done
    echo "$out"
  '';
in
{
  bluetooth = {
    format = "${icons.bluetooth}";
    format-on = "${icons.bluetooth}";
    format-off = "${icons.bluetooth_off}";
    format-disabled = "${icons.bluetooth_off}";
    format-connected = "${icons.bluetooth} {num_connections}";
    tooltip-format = "{controller_alias}\n{num_connections} connected";
    tooltip-format-connected = "{controller_alias}\n{device_enumerate}";
    tooltip-format-enumerate-connected = "{device_alias}";
    tooltip-format-enumerate-connected-battery = "{device_alias} {device_battery_percentage}%";
    on-click = "~/.local/bin/exam-hint";
    on-click-right = "bluetoothctl power toggle";
  };
  "custom/hintl" = {
    exec = "${hint} left";
    signal = 8;
    tooltip = false;
  };

  "custom/hint" = {
    exec = "${hint} right";
    signal = 8;
    tooltip = false;
  };

  "group/bt" = {
    orientation = "horizontal";
    modules = [ "custom/hintl" "bluetooth" "custom/hint" ];
  };
}
