# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, username, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./plymouth.nix
      ../../modules/system/ncalayer.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 20;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    min-free = 5 * 1024 * 1024 * 1024;
    max-free = 20 * 1024 * 1024 * 1024;
  };
  programs.nh = {
    enable = true;
    flake = "${config.users.users.${username}.home}/dotfiles";
    clean.enable = true;
    clean.extraArgs = "--keep 20 --keep-since 14d";
  };

  services.journald.extraConfig = "SystemMaxUse=200M";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [ networkmanager-openvpn ];

  # Set your time zone.
  time.timeZone = "Asia/Almaty";

  # Select internationalisation properties. Whole system uses English; the
  # day/month names on the lock screen follow LC_TIME (en_US).
  i18n.defaultLocale = "en_US.UTF-8";
  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-volman
      thunar-archive-plugin
      thunar-media-tags-plugin
    ];
  };
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];


  # Login is handled by greetd: it auto-starts the Hyprland session, which
  # immediately launches hyprlock (see modules/home/hyprland/exec-once.nix).
  # So the very first screen at boot is the hyprlock lock screen itself.
  services.xserver.enable = true;
  services.greetd = {
    enable = true;
    settings.default_session = {
      # Redirect UWSM's verbose launcher chatter away from the VT so boot and
      # shutdown stay clean under the Plymouth splash. Real compositor logs are
      # still captured by the systemd user units (journalctl --user).
      command = "sh -c 'exec uwsm start -eD Hyprland hyprland.desktop >/dev/null 2>&1'";
      user = username;
    };
  };

  # Boot speed: don't block boot waiting for full network readiness, and start
  # the (rootful) docker daemon on demand instead of at boot — docker is used
  # rootless here, so the system daemon isn't needed during startup.
  systemd.services.NetworkManager-wait-online.enable = false;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  custom.ncalayer.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "networkmanager" "wheel" "docker" "vboxusers" "wireshark" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    rootless.enable = true;
    rootless.setSocketVariable = true;
    daemon.settings = {
      default-address-pools = [
        { base = "172.80.0.0/12"; size = 24; }
      ];
    };
  };

 
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (callPackage ../../modules/system/cisco-packet-tracer-901.nix { })
    google-chrome
    telegram-desktop
    vscode
    android-studio
    android-tools
    git
    gh
    docker 
    docker-compose
    ngrok
    python313
    python313Packages.pip
    cloudflared
    spotify
    discord
    filezilla
    kitty
    waybar
    pavucontrol
    wl-clipboard
    hyprland
    grim
    slurp
    unrar
    unzip
    tree
    gnumake
    gparted
    sqlite
    libreoffice
    (pkgs.openjdk17.override { enableJavaFX = true; })
    pcsclite
    ccid
    pcsc-tools
    nssTools
    libnotify
    networkmanagerapplet
    networkmanager_dmenu
    openvpn
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    nerd-fonts.fira-code
    font-awesome
    material-design-icons
    material-icons
    noto-fonts-color-emoji
    twemoji-color-font
  ];
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      openssl
      curl
      glibc
    ];
  };

  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };
  users.extraGroups.vboxusers.members = [ username ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
