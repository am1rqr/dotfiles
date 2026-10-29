let icons = import ../icons.nix; in
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
    on-click = "blueman-manager";
    on-click-right = "bluetoothctl power toggle";
  };
}
