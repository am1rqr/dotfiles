{
  modules = ''
    #window,
    #clock,
    #battery,
    #backlight,
    #cpu,
    #memory,
    #network,
    #pulseaudio,
    #custom-language,
    #custom-power {
      background-color: @bg0;
      padding: 2px 14px;
      margin: 4px 3px;
      border-radius: 14px;
      border: 1px solid rgba(137, 180, 250, 0.12);
    }

    #window {
      color: @lavender;
      font-style: italic;
      padding: 2px 16px;
    }

    #window.empty {
      background: transparent;
      border: none;
      color: transparent;
    }

    #clock {
      color: @lavender;
      font-weight: 700;
      font-size: 14px;
      padding: 2px 18px;
      background-color: @bg0;
      border: 1px solid rgba(180, 190, 254, 0.25);
    }

    #cpu {
      color: @blue;
    }

    #memory {
      color: @pink;
    }

    #battery {
      color: @green;
    }

    #battery.charging,
    #battery.plugged {
      color: @green;
    }

    #battery.warning:not(.charging) {
      color: @yellow;
    }

    #battery.critical:not(.charging) {
      color: @red;
      animation: blink 1s linear infinite;
    }

    @keyframes blink {
      to {
        color: @fg0;
      }
    }

    #network {
      color: @yellow;
    }

    #network.disconnected {
      color: @red;
    }

    #pulseaudio {
      color: @mauve;
    }

    #pulseaudio.muted {
      color: @red;
    }

    #backlight {
      color: @peach;
    }

    #custom-language {
      padding: 2px 14px;
      min-width: 30px;
      background-color: @bg0;
      border: 1px solid rgba(137, 180, 250, 0.12);
    }

    #custom-power {
      color: @red;
      font-size: 14px;
      padding: 2px 16px 2px 12px;
      transition: background-color 0.2s ease, color 0.2s ease;
    }

    #custom-power:hover {
      background-color: @red;
      color: @bg0;
    }
  '';
}
