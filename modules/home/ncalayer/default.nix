{ config, osConfig, pkgs, lib, ... }:

let
  home = config.home.homeDirectory;
  jar = "${home}/.local/share/NCALayer/ncalayer.jar";

  # NCALayer must run on the JRE 8 that NCA RK ships inside the installer, not on a
  # system JDK. Its storage dialog holds a hidden ComboBox<Smartcard> that is
  # setVisible(false) but still managed, so GridPane lays it out with a null
  # value — and from JavaFX 9 on, updateDisplayText hands that null straight to
  # the converter (`object.getTerminalName()`) whenever promptText is unset.
  # Result: NullPointerException on every pulse, no dialog, CSR_GENERATING_FAILURE
  # on did.pki.gov.kz. JavaFX 8 falls back to promptText instead and is fine.
  #
  # The jar and the JRE live outside this repo (proprietary, 287 MB): see
  # README.md in this directory for where to get them.
  jre = "${home}/.local/share/NCALayer/jre8";

  # That JRE is a foreign binary; nix-ld resolves its interpreter, but JavaFX
  # dlopens its GTK backend later, so the libraries need to be on the search
  # path too. GTK 2 is deliberately absent: libglassgtk2 segfaults against a
  # modern GTK 2, so the launcher pins jdk.gtk.version=3.
  libs = lib.makeLibraryPath (with pkgs; [
    gtk3
    glib
    at-spi2-core
    cairo
    pango
    gdk-pixbuf
    freetype
    fontconfig
    alsa-lib
    libGL
    libx11
    libxext
    libxrender
    libxtst
    libxi
    libxxf86vm
    stdenv.cc.cc
    zlib
  ]);

  # Without compiled GSettings schemas GTK 3 aborts with a fatal GLib-GIO-ERROR
  # the moment the first dialog opens.
  schemas = lib.concatStringsSep ":" [
    "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
    "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
    "${pkgs.glib.out}/share/gsettings-schemas/${pkgs.glib.name}"
  ];

  # The vendor launcher resolves libpcsclite by running `ldd /usr/bin/pcsc_scan`,
  # which finds nothing on NixOS, so the path has to be passed explicitly — but
  # only when a reader is actually plugged in. With the library loaded and zero
  # readers, SCardListReaders returns SCARD_E_NO_READERS_AVAILABLE and the JDK
  # turns that into `CardException: list() failed` instead of an empty list,
  # which breaks the storage list. A reader plugged in later needs a restart.
  pcscLib = "${pkgs.pcsclite.lib}/lib/libpcsclite.so.1";

  ncalayer = pkgs.writeShellApplication {
    name = "ncalayer";
    runtimeInputs = [ pkgs.pcsc-tools ];
    text = ''
      if [ ! -x ${jre}/bin/java ] || [ ! -f ${jar} ]; then
        echo "ncalayer: ${jre} or ${jar} missing, see modules/home/ncalayer/README.md" >&2
        exit 1
      fi

      export LD_LIBRARY_PATH="${libs}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      export NIX_LD_LIBRARY_PATH="${libs}''${NIX_LD_LIBRARY_PATH:+:$NIX_LD_LIBRARY_PATH}"
      export XDG_DATA_DIRS="${schemas}''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
      export GDK_BACKEND=x11

      smartcard=()
      if pcsc_scan -r 2>/dev/null | grep -qE '^[[:space:]]*[0-9]+:'; then
        smartcard=(-Dsun.security.smartcardio.library=${pcscLib})
      fi

      exec ${jre}/bin/java \
        -Djdk.gtk.version=3 \
        -Dprism.order=sw \
        "''${smartcard[@]}" \
        -jar ${jar} "$@"
    '';
  };

  # NCA RK roots, in DER as certutil wants them.
  ncalayer-certs = pkgs.writeShellApplication {
    name = "ncalayer-certs";
    runtimeInputs = [ pkgs.nssTools ];
    text = ''
      add() {
        certutil -A -n "$2" -t "TCu,Cu," -i "$3" -d "$1" 2>/dev/null || true
      }
      for db in "$HOME"/.pki/nssdb "$HOME"/.config/mozilla/firefox/*/ "$HOME"/.mozilla/firefox/*/; do
        [ -f "$db/cert9.db" ] || continue
        add "sql:$db" root_rsa.cer ${./certs/root_rsa.cer}
        add "sql:$db" nca_rsa.cer ${./certs/nca_rsa.cer}
        echo "certs -> $db"
      done
    '';
  };
in
{
  config = lib.mkIf osConfig.custom.ncalayer.enable {
    home.packages = [ ncalayer ncalayer-certs ];

    home.file.".local/share/icons/ncalayer.png".source = ./ncalayer.png;

    xdg.desktopEntries.ncalayer = {
      name = "NCALayer";
      comment = "Digital signature (EDS) client";
      exec = "ncalayer";
      icon = "ncalayer";
      terminal = false;
      categories = [ "Network" "RemoteAccess" ];
    };

    wayland.windowManager.hyprland.settings.exec-once = [ "ncalayer" ];

    home.activation.ncalayerCerts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ${ncalayer-certs}/bin/ncalayer-certs || true
    '';
  };
}
