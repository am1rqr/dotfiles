{
  bind = [
    "$mainMod, Return, exec, $terminal"
    # Zed is one process for all windows and its graceful full-quit is slow
    # (collab/DBus teardown). With >1 window, close just the focused one
    # (killactive is fast — the slow teardown only fires on the last window).
    # On the last window, hard-kill by the focused PID — never a broad `pkill -f`,
    # which matches every process's cmdline and could take out Chrome et al.
    "$mainMod, Q, exec, if hyprctl activewindow -j | grep -q dev.zed.Zed; then if [ \"$(hyprctl clients -j | jq '[.[]|select(.class==\"dev.zed.Zed\")]|length')\" -gt 1 ]; then hyprctl dispatch killactive; else kill -9 \"$(hyprctl activewindow -j | jq .pid)\"; fi; else hyprctl dispatch killactive; fi"
    "$mainMod, M, exit"
    "$mainMod, E, exec, $fileManager"
    "$mainMod, V, togglefloating"
    "$mainMod, R, exec, $menu"
    "$mainMod, P, pseudo"
    "$mainMod, J, togglesplit"
    "$mainMod, F, fullscreen"
    "$mainMod, D, exec, rofi -show drun"
    "$mainMod, left, movefocus, l"
    "$mainMod, right, movefocus, r"
    "$mainMod, up, movefocus, u"
    "$mainMod, down, movefocus, d"
    "$mainMod, 1, workspace, 1"
    "$mainMod, 2, workspace, 2"
    "$mainMod, 3, workspace, 3"
    "$mainMod, 4, workspace, 4"
    "$mainMod, 5, workspace, 5"
    "$mainMod, 6, workspace, 6"
    "$mainMod, 7, workspace, 7"
    "$mainMod, 8, workspace, 8"
    "$mainMod, 9, workspace, 9"
    "$mainMod, 0, workspace, 10"
    "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
    "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
    "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
    "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
    "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
    "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
    "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
    "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
    "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
    "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
    "$mainMod, S, togglespecialworkspace, magic"
    "$mainMod SHIFT, S, movetoworkspacesilent, special:magic"
    "$mainMod, mouse_down, workspace, e+1"
    "$mainMod, mouse_up, workspace, e-1"
    ",Print, exec, grim -o $(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name') - | tee ~/Screenshots/screenshot_$(date +%F_%T).png | wl-copy"
    "SHIFT, Print, exec, grim -g \"$(slurp)\" - | tee ~/Screenshots/screenshot_$(date +%F_%T).png | wl-copy"
    # Aula F75 has no Print key — same actions on Super+C
    "$mainMod, C, exec, grim -o $(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name') - | tee ~/Screenshots/screenshot_$(date +%F_%T).png | wl-copy"
    "$mainMod SHIFT, C, exec, grim -g \"$(slurp)\" - | tee ~/Screenshots/screenshot_$(date +%F_%T).png | wl-copy"
    "$mainMod ALT, C, exec, grim -g \"$(slurp)\" - | wl-copy"
  ];

  bindel = [
    ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
    ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
    ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
  ];

  bindl = [
    ",XF86AudioNext, exec, playerctl next"
    ",XF86AudioPause, exec, playerctl play-pause"
    ",XF86AudioPlay, exec, playerctl play-pause"
    ",XF86AudioPrev, exec, playerctl previous"
  ];

  bindm = [
    "$mainMod, mouse:272, movewindow"
    "$mainMod, mouse:273, resizewindow"
  ];
}
