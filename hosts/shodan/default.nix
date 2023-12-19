{ pkgs, config, inputs, outputs, lib, ... }: {

  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    outputs.nixosModules.settings
    ./river
  ];

  settings.stateVersion = "24.05";
  settings = {
    name = "Pavel Král";
    username = "pkral";
    email = "pavel.kral@gmail.com";
    profile = "pkral78";
  };

  # environment = {
  #   persistence = {
  #     "/persist".directories = [ "/var/lib/systemd" "/var/log" "/srv" ];
  #   };
  #   enableAllTerminfo = true;
  # };

  environment.systemPackages = with pkgs; [
    # podman-compose
    # docker_compose
    (ripgrep.override { withPCRE2 = true; })
    bat
    bc
    bind
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


  nixpkgs.config.allowUnfree = true;
  # nixpkgs = {
  #   overlays = builtins.attrValues outputs.overlays;
  # };

  nix = {
    package = lib.mkDefault pkgs.nix;
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


  # TODO: theme "greeter" user GTK instead of using pkral to login
  # services.greetd.settings.default_session.user = config.settings.username;

  networking = {
    hostName = "shodan";
    useNetworkd = true;
    useDHCP = false;
    enableIPv6 = false;
    firewall.enable = false;
    extraHosts = "
       10.0.0.13 neutron postgres mongo kafka influxdb
    ";
    domain = "kralovi.net";
  };


  programs = {
    zsh.enable = true;
    dconf.enable = true;
    kdeconnect.enable = true;
  };
  programs.fuse.userAllowOther = true;

# Increase open file limit for sudoers
  security.pam.loginLimits = [
    {
      domain = "@wheel";
      item = "nofile";
      type = "soft";
      value = "524288";
    }
    {
      domain = "@wheel";
      item = "nofile";
      type = "hard";
      value = "1048576";
    }
  ];
  security.pam.services = { swaylock = { }; };
  security.sudo.wheelNeedsPassword = false;

  services.getty.autologinUser = "${config.settings.username}";
# services.geoclue2.enable = true;

  # Enable sound.
  sound.enable = true;
  sound.mediaKeys.enable = true;

  system.stateVersion = config.settings.stateVersion;

  systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "info";
  systemd.network = {
    enable = true;
    config = {
      # routeTables.custom = 23;
    };
    netdevs = { };
    networks = {
      "50-wired" = {
        enable = true;
        name = "enp73s0";
        address = [ "192.168.88.60/24" ];
        gateway = [ "192.168.88.1" ];
        dns = [ "10.0.0.1" ];
        DHCP = "no";
      };
    };
  };

  time.timeZone = "Europe/Prague";
  # i18n.defaultLocale = "cs_CZ.UTF-8";
  # TODO
  # LC_MEASUREMENT=cs_CZ.UTF-8
  # LC_MONETARY=cs_CZ.UTF-8
  # LC_NUMERIC=cs_CZ.UTF-8
  # LC_PAPER=cs_CZ.UTF-8
  # LC_TIME=cs_CZ.UTF-8

  virtualisation.libvirtd = {
    enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.common.default = "*";
  };

#####

  users.mutableUsers = false;
  users.users.${config.settings.username} = {
    isNormalUser = true;
    createHome = true;
    shell = pkgs.zsh;
    hashedPassword =
      "$6$EQGBQvubTZ$um26okodYC7rw8SwnJToA.2UxawxO7ZDuf3KsCvTXbDIscDcmTxfx/YzQNYc0EEntbXGSjFA79nuzO5kaNeIz0";
    uid = 1000;
    extraGroups = [
      "wheel"
      "video"
      "audio"
    ];
    #  ++ ifTheyExist [
    #   "network"
    #   "wireshark"
    #   "i2c"
    #   "mysql"
    #   "docker"
    #   "podman"
    #   "git"
    #   "libvirtd"
    #   "deluge"
    #   "plugdev"
    #   "dialout"
    # ];

    # openssh.authorizedKeys.keys = [
    #   "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDci4wJghnRRSqQuX1z2xeaUR+p/muKzac0jw0mgpXE2T/3iVlMJJ3UXJ+tIbySP6ezt0GVmzejNOvUarPAm0tOcW6W0Ejys2Tj+HBRU19rcnUtf4vsKk8r5PW5MnwS8DqZonP5eEbhW2OrX5ZsVyDT+Bqrf39p3kOyWYLXT2wA7y928g8FcXOZjwjTaWGWtA+BxAvbJgXhU9cl/y45kF69rfmc3uOQmeXpKNyOlTk6ipSrOfJkcHgNFFeLnxhJ7rYxpoXnxbObGhaNqn7gc5mt+ek+fwFzZ8j6QSKFsPr0NzwTFG80IbyiyrnC/MeRNh7SQFPAESIEP8LK3PoNx2l1M+MjCQXsb4oIG2oYYMRa2yx8qZ3npUOzMYOkJFY1uI/UEE/j/PlQSzMHfpmWus4o2sijfr8OmVPGeoU/UnVPyINqHhyAd1d3Iji3y3LMVemHtp5wVcuswABC7IRVVKZYrMCXMiycY5n00ch6XTaXBwCY00y8B3Mzkd7Ofq98YHc= (none)"
    # ];
    # passwordFile = config.sops.secrets.misterio-password.path;
    packages = [ pkgs.home-manager ];
  };

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
  };

  home-manager.users.${config.settings.username} = import ./home.nix;

}
