{ pkgs, config, nixosConfig, inputs, outputs, lib, ... }:
let
  names = builtins.attrNames config;
in
{
  systemd.user.startServices = "sd-switch";

  nixpkgs.config.allowUnfree = true;

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  programs.vscode = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home = {
    # TODO check config what contains
    #username = builtins.trace "Debug: ${builtins.toJSON names}" nixosConfig.settings.username;
    username = nixosConfig.settings.username;
    homeDirectory = "/home/${config.home.username}";
    # TODO inherit from system
    #stateVersion = lib.mkDefault "23.05";
    stateVersion = nixosConfig.settings.stateVersion;

    # stateVersion = system.stateVersion;
    #stateVersion = outputs.nixosConfigurations.${config.settings.hostname}.config.system.stateVersion;
    # stateVersion = current.config.system.stateVersion;
  };

  home.packages = with pkgs; [
    nerdfonts
    feh
    firefox
    google-chrome
    brave
    #nitrokey-app
    slack
    sublime-merge-dev
    remmina
    tilda
    thunderbird
    libreoffice-fresh
    #libreoffice
    vlc
    wine
    tdesktop
    wireshark

    alacritty
    openjdk8
    discord
    sqlitebrowser
    zim
    #stm32cubemx
    #trezor-suite
    #ledger-live-desktop

    # jetbrains.pycharm-professional
    # jetbrains.idea-ultimate
    # jetbrains.webstorm
    # jetbrains.clion
    # jetbrains.datagrip
    # jetbrains.goland
    # android-studio

    bc
    bat
    file
    coreutils
    ffmpeg
    ispell
    jq
    killall
    pv
    python39
    stdenv
    tmuxinator
    unzip
    zip
    p7zip
    xz
    tk
    fzf
    patchelf
    openssl
    exiftool
    pdftk
    openvpn
    opensc
    gopass
    envsubst
    nixfmt
    neovim
    lsd
    rnix-lsp
    nixpkgs-fmt
    nil
    mc

    docker-compose
    azure-cli

  ];



}

# config:
# ["_module","accounts","assertions","dconf","editorconfig","fonts","gtk","home","home-files","i18n","launchd","lib","manual","meta","news","nix","nixpkgs","pam","programs","qt","services","specialisation","specialization","submoduleSupport","systemd","targets","warnings","wayland","xdg","xfconf","xresources","xsession"]