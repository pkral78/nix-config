{ pkgs, config, inputs, outputs, lib, ... }: {

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

  security.sudo.wheelNeedsPassword = false;
  services.getty.autologinUser = "${config.settings.username}";

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
}
