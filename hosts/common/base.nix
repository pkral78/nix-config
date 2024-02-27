{ pkgs, config, inputs, outputs, lib, ... }: {

  settings.stateVersion = "24.05";

  settings = {
    name = "Pavel Král";
    username = "pkral";
    email = "pavel.kral@gmail.com";
    profile = "pkral78";
  };

  nixpkgs.config.allowUnfree = true;
  # nixpkgs = {
  #   overlays = builtins.attrValues outputs.overlays;
  # };

  nix = {
    #package = lib.mkDefault pkgs.nix;
    package = pkgs.nixUnstable;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;
      max-jobs = lib.mkDefault 12;
    };
  };
  # # For debugging only
  # nix.extraOptions = ''
  #   keep-outputs = true
  #   keep-derivations = true
  # '';
  # nix.useSandbox = "relaxed";
  # nix.trustedUsers = [ config.settings.username ];

  environment.systemPackages = with pkgs; [
    (ripgrep.override { withPCRE2 = true; })
    bat
    bc
    bind
    binutils
    borgbackup
    bottom # System viewer
    comma
    coreutils
    curl
    httpie # Better curl
    dos2unix
    envsubst
    fd
    file
    fwupd
    fzf
    git
    gnupg
    gnutls
    htop
    hwinfo
    kakoune
    eza
    jq
    lsd
    killall
    lsof
    ncdu # Disk usage
    neovim
    helix
    nixfmt
    nixpkgs-fmt
    nmap
    mc
    opensc
    openssl
    openvpn
    p7zip
    patchelf
    pciutils
    psmisc
    rnix-lsp
    rsync
    tcpdump
    tpm2-tools
    traceroute
    unrar
    unzip
    usbutils
    wget
    wireguard-tools
    xz
    zstd
    zip
  ];


  environment.variables = {
    #    EDITOR = "urxvt";
  };

  fonts = {
    packages = with pkgs; [
      corefonts
      inconsolata
      libertine
      libre-baskerville
      (nerdfonts.override {
        fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono" ];
      })
    ];
  };


  programs = {
    zsh.enable = true;
    dconf.enable = true;
  };
  programs.fuse.userAllowOther = true;

  time.timeZone = "Europe/Prague";
  # i18n.defaultLocale = "cs_CZ.UTF-8";
  # TODO
  # LC_MEASUREMENT=cs_CZ.UTF-8
  # LC_MONETARY=cs_CZ.UTF-8
  # LC_NUMERIC=cs_CZ.UTF-8
  # LC_PAPER=cs_CZ.UTF-8
  # LC_TIME=cs_CZ.UTF-8


}
