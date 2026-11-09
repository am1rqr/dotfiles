{
  services.mako = {
    enable = true;
    extraConfig = ''
      font=JetBrainsMono Nerd Font 13
      background-color=#1e1e2e
      text-color=#cdd6f4
      border-color=#313244
      border-radius=8
      border-size=1
      default-timeout=5000
      anchor=bottom-left
      margin=20
      invisible=1

      [app-name=exam-hint]
      invisible=0
      font=JetBrainsMono Nerd Font Bold 20
      background-color=#00000000
      text-color=#000000
      border-color=#00000000
      border-size=0
      width=32
      height=32
      padding=0
      default-timeout=5000
      format=%s
    '';
  };
}
