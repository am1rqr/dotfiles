# NCALayer

Launcher for [NCALayer](https://pki.gov.kz), the Kazakhstan e-signature (EDS) client, on NixOS.
It is optional and off unless `custom.ncalayer.enable = true;` is set in `hosts/nixos/configuration.nix`.

The vendor files are proprietary and are **not** part of this repository. Take them from the
official installer and place them here:

```
~/.local/share/NCALayer/ncalayer.jar   # the application
~/.local/share/NCALayer/jre8/          # the JRE 8 bundled with the installer
```

It must be that JRE 8: from JavaFX 9 on, the storage dialog hits a `NullPointerException`
and the dialog never appears (details in `default.nix`).

When enabled, the option also turns on `pcscd`, trusts the NCA RK root certificates system-wide,
imports them into Firefox/Chrome NSS stores on activation, and autostarts `ncalayer` with Hyprland.
