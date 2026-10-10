# Boot splash (Plymouth) + silent boot + hidden generation menu.
{ pkgs, ... }:

let
  radarTheme = pkgs.runCommand "plymouth-radar-theme" { } ''
    d=$out/share/plymouth/themes/radar
    mkdir -p $d
    cp ${./plymouth/radar}/progress-*.png $d/
    cp ${./plymouth/radar}/radar.script $d/
    cp ${./plymouth/radar}/radar.plymouth $d/
    sed -i "s|@THEMEDIR@|$d|g" $d/radar.plymouth
  '';
in
{
  boot.plymouth = {
    enable = true;
    themePackages = [ radarTheme ];
    theme = "radar";
  };

  # Silent boot: hide kernel / systemd console messages and the cursor.
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.kernelParams = [
    "quiet"
    "splash"
    "loglevel=3"
    "udev.log_level=3"
    "rd.udev.log_level=3"
    "systemd.show_status=false"
    "rd.systemd.show_status=false"
    "vt.global_cursor_default=0"
  ];

  # Boot menu: load the latest generation immediately.
  # Hold Space during power-on to show the menu and pick an older generation.
  boot.loader.timeout = 0;
}
