{ pkgs, lib, config, inputs, ... }:
{
  programs.river = {
    enable = true;
    extraPackages = with pkgs; [
      foot
      kitty
      swaylock-effects # lockscreen
      pavucontrol
      swayidle
      xwayland
      (i3pystatus.override {
        extraLibs = [ python3.pkgs.keyrings-alt python3.pkgs.paho-mqtt ];
      })
      i3bar-river
      rofi-wayland
      rofi-rbw
      gnome.eog
      libnotify
      dunst # notification daemon
      kanshi # auto-configure display outputs
      wdisplays
      wl-clipboard
      blueberry
      sway-contrib.grimshot # screenshots
      wtype

      pavucontrol
      evince
      libnotify
      pamixer
      networkmanagerapplet
      gnome.file-roller
      gnome.nautilus
      firefox
      chromium

      # Somehow xdg.portal services do not really work for me.
      # Instead I re-start xdg-desktop-portal and xdg-desktop-portal wlr from sway itself
      xdg-desktop-portal
      xdg-desktop-portal-wlr
    ];
  };

  # TODO pkral is this needed?
  security.pam.services = { swaylock = { }; };
  security.polkit.enable = true;

  # TODO pkral in favor of xdb-desktop-portal?
  # xdg.portal = {
  #   enable = true;
  #   wlr.enable = true;
  #   config.common.default = "*";
  # };

  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;
  fonts.enableDefaultPackages = true;

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "river";
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  environment.systemPackages = with pkgs; [
    wayland-utils
    xdg-utils
    # polkit agent
    polkit_gnome

    # gtk3 themes
    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    lxappearance

    # screen brightness
    brightnessctl

    # Here we but a shell script into path, which lets us start river.service (after importing the environment of the login shell).
    (pkgs.writeTextFile {
      name = "startriver";
      destination = "/bin/startriver";
      executable = true;
      text =
        let
          schema = pkgs.gsettings-desktop-schemas;
          datadir = "${schema}/share/gsettings-schemas/${schema.name}";
        in
        ''
          #! ${pkgs.bash}/bin/bash

          #${pkgs.rbw}/bin/rbw unlock
          ${pkgs.openssh}/bin/ssh-add
          export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
          # first import environment variables from the login manager
          systemctl --user unset-environment DISPLAY WAYLAND_DISPLAY
          systemctl --user import-environment
          # then start the service
          exec systemctl --user start river.service
        '';
    })
  ] ++ [
    inputs.nixpkgs-wayland.packages.${system}.wlr-randr
  ];

  # for polkit
  #environment.pathsToLink = [ "/libexec" ];

  #qt.platformTheme = "qt5ct";

  # brightnessctl
  users.users."${config.settings.username}".extraGroups = [ "video" ];

  #systemd.user.targets.sway-session = {
  #  description = "Sway compositor session";
  #  documentation = [ "man:systemd.special(7)" ];
  #  bindsTo = [ "graphical-session.target" ];
  #  wants = [ "graphical-session-pre.target" ];
  #  after = [ "graphical-session-pre.target" ];
  #};

  systemd.user.services.river = {
    description = "River - Wayland window manager";
    documentation = [ "man:river(5)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
    # We explicitly unset PATH here, as we want it to be set by
    # systemctl --user import-environment in startriver
    environment.PATH = lib.mkForce null;
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.river}/bin/river";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # systemd.user.services.kanshi = {
  #     enable = true;
  #     description = "kanshi daemon";
  #     # wantedBy = [];
  #     after = ["river.service"]; # Ensure kanshi starts after river
  #     partOf = ["river.service"]; # Optional: stop kanshi when river stops
  #     serviceConfig = {
  #       Type = "simple";
  #       ExecStart = ''${pkgs.kanshi}/bin/kanshi'';
  #     };

  #   # profiles = {
  #   #   qemu = {
  #   #     outputs = [
  #   #       { criteria = "Virtual-1";
  #   #         status = "enable";
  #   #         scale = 2;
  #   #         mode = "2560x1440";
  #   #       }
  #   #     ];
  #   #   };
  #   # };
  # };
}
