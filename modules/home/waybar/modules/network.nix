let icons = import ../icons.nix; in
{
  network = {
    format-wifi = "${icons.wifi} {signalStrength}%";
    format-ethernet = "${icons.eth} ";
    format-disconnected = "${icons.wifi_off} ";
    tooltip-format = "{ifname}: {ipaddr}/{cidr}";
    tooltip-format-wifi = "{essid} ({signalStrength}%)\n{ipaddr}/{cidr}";
    tooltip-format-disconnected = "Disconnected";
    on-click = "networkmanager_dmenu";
    on-click-right = "nm-connection-editor";
  };
}
