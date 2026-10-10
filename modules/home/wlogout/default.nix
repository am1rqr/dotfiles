{ pkgs, ... }:

{
  programs.wlogout = {
    enable = true;

    layout = [
      { label = "lock";     action = "lockscreen";        text = "Lock";     keybind = "l"; }
      { label = "logout";   action = "hyprctl dispatch exit"; text = "Logout";   keybind = "e"; }
      { label = "suspend";  action = "systemctl suspend"; text = "Suspend";  keybind = "u"; }
      { label = "reboot";   action = "systemctl reboot";  text = "Reboot";   keybind = "r"; }
      { label = "shutdown"; action = "systemctl poweroff"; text = "Shutdown"; keybind = "s"; }
    ];

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 14px;
        background-image: none;
        transition: background-color 0.2s ease, color 0.2s ease, border 0.2s ease;
      }

      window {
        background-color: rgba(26, 36, 48, 0.85);
      }

      button {
        color: #c1dbf1;
        background-color: rgba(46, 62, 79, 0.95);
        border: 1px solid rgba(137, 180, 250, 0.12);
        border-radius: 20px;
        margin: 12px;
        background-repeat: no-repeat;
        background-position: center 42%;
        background-size: 72px;
        outline: none;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
      }

      button:focus {
        color: #c1dbf1;
        background-color: rgba(46, 62, 79, 0.95);
        border: 1px solid rgba(137, 180, 250, 0.45);
      }

      button:hover {
        color: #1a2430;
        background-color: #6395da;
        border: 1px solid #add1fd;
      }

      #shutdown:hover {
        background-color: #c2748c;
        border: 1px solid #c98fac;
      }

      #lock     { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png")); }
      #logout   { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png")); }
      #suspend  { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png")); }
      #reboot   { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png")); }
      #shutdown { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png")); }
    '';
  };
}
