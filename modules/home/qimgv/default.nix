{ pkgs, lib, ... }:

let
  colors = import ./colors.nix;

  imageTypes = [
    "image/jpeg"
    "image/png"
    "image/gif"
    "image/webp"
    "image/bmp"
    "image/tiff"
    "image/avif"
    "image/heif"
    "image/jxl"
    "image/svg+xml"
    "image/vnd.microsoft.icon"
  ];

  # Only the containers qimgv itself whitelists — anything else still goes to
  # the previous handler instead of opening into an empty viewer.
  videoTypes = [
    "video/mp4"
    "video/x-matroska"
    "video/webm"
    "video/quicktime"
    "video/x-msvideo"
    "video/mpeg"
    "video/x-ms-wmv"
    "video/x-flv"
  ];

  qimgvFor = types: lib.genAttrs types (_: "qimgv.desktop");
in
{
  home.packages = [ pkgs.qimgv ];

  # qimgv rewrites its own config on exit, so the store symlink has to be
  # re-forced on every rebuild — GUI-side setting changes are not persistent.
  home.file.".config/qimgv/qimgv.conf" = {
    force = true;
    text = lib.generators.toINI { } {
      General = {
        firstRun = false;
        showChangelogs = false;
        # Pinned to the packaged version: a 0.0.0 "last version" makes qimgv
        # run its upgrade fixups, which swap the scroll-wheel direction.
        lastVerMajor = 1;
        lastVerMinor = 0;
        lastVerMicro = 3;
        language = "en_US";

        # Colors come from theme.conf below, not from the Qt palette.
        useSystemColorScheme = false;

        videoPlayback = true;
        playVideoSounds = true;

        # Thumbnail strip always visible, not just in fullscreen.
        panelEnabled = true;
        panelFullscreenOnly = false;
        panelPosition = "bottom";
        panelPreviewsSize = 140;
        panelCenterSelection = true;
        squareThumbnails = false;

        # Built-in folder browser: grid of previews, folders first.
        folderViewMode = 2;
        folderViewIconSize = 140;
        sortingMode = 0;
        sortFolders = true;

        infoBarWindowed = true;
        infoBarFullscreen = true;
        windowTitleExtendedInfo = true;

        defaultFitMode = 0;
        keepFitMode = false;
        smoothUpscaling = true;
        smoothAnimatedImages = true;
        expandImage = false;
        unlockMinZoom = true;
        zoomStep = 0.2;

        usePreloader = true;
        thumbnailCache = true;
        unloadThumbs = true;
        thumbnailerThreads = 4;
        memoryAllocationLimit = 2048;

        enableSmoothScroll = true;
        cursorAutohiding = true;
        confirmDelete = true;
        confirmTrash = true;
        slideshowInterval = 3000;
        JPEGSaveQuality = 95;
      };
    };
  };

  home.file.".config/qimgv/theme.conf" = {
    force = true;
    text = lib.generators.toINI { } { Colors = colors; };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = qimgvFor (imageTypes ++ videoTypes) // {
      "text/html" = "google-chrome.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "x-scheme-handler/about" = "google-chrome.desktop";
      "x-scheme-handler/unknown" = "google-chrome.desktop";
      "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
      "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
      "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
    };
    # qimgv.desktop only declares a handful of types itself.
    associations.added = lib.mapAttrs (_: v: [ v ]) (qimgvFor (imageTypes ++ videoTypes));
  };

  # Both lists already exist as plain files from before this module.
  xdg.configFile."mimeapps.list".force = true;
  xdg.dataFile."applications/mimeapps.list".force = true;
}
