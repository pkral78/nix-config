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

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCRX/fQGNyRZ4TMwm2a1xSfV/6xQalYRoawu8det/Ypss9CZILtg9GGdgCPsTBKu7vqFcmoPp870yPVhZ0S8g3xEKLK+GQNDRdHScBaAy+cuaph9QxMJ0n3qnf3+HOF1Pzsb+n0eAJ7WGQ88r8vAC7pOWmXUpJVaW+DzTuK8+hfeyjoaUqmK+z6IVZ+JAPbK6N9vBo9AHdzHEhmpuMVuz7LQ9HKwSPiOA9rlI0g1EmA7Dm3hIJaf2sFdXC2lNTQCVX9+4pYUEeqywf6hF1DZ7jwLEjFa7Uw853W57M+lGEyPWMZ373DYZaI92I7qGVFoTuvzbCVWv+/wgFPTcq4G83T"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPi+YHT3MbhW5zSmPx0cq2PmsxW3cHT427cMNBLoVP+V wintermute-key-231008"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDFVGGrpuKfLtgRcU1Eong2wTxW8NhRq9Lu/Oi+O2QDuXkaGDsU+AeLGE3bvfrO/4qBEk0Y/McRtccmA4mlEkVKq3Ou/GEZOPRBZQrIKxQYitIQ2LpsVnaUTqiHNn8MyfG0XDr1ItarMutVmaheH32oCWEba+2bxMsAZhCcJhd2YiDYFWW630rQVgsD8n/hOdax32JQrqaGOtfsYEiqz5VgJK6ZWvOUTUQMIO89N/nBTcfWUMa0UKXqZ3kZoDXjz5XUcG9XRG1bRJWN573c+sisfvHSxIUbjyepI5v+BNBQZWeIZtjBS0iJNRgiU1PjmdetOBuCo6rUnlcvaLKSwEE9I1SFo8dbFvt4K7NsZ3bR210+HN+Fs2/BfEvYhm+NrIpDiVmgMnLf8/2kQGiCjWSZ/z4aj+4G19xhQ4tbrWEeaMWYwaa4roMbD3SmmKG288033KFRLXe8e1klZv6ydkAdOK7vQOiVnUYKbM+sRHmipPcOxGa3t4ciL0hPvoRMv4kScKr68aqBWRDyX3uwpXl9PEAEuVwbBcdOgKD/1BzjbhHKLzHD/30r5seK/W1/dh0euONP79vjDOavhplSkj+OA7Mf22ogkfFoB2jbvqikbRhSQTc/RGLoSywjZKMMOUw4xCDFsxRMimR3+7Gq3VT3g1dKEmvTVAYiuZT5qcVNBw=="
    #   "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDci4wJghnRRSqQuX1z2xeaUR+p/muKzac0jw0mgpXE2T/3iVlMJJ3UXJ+tIbySP6ezt0GVmzejNOvUarPAm0tOcW6W0Ejys2Tj+HBRU19rcnUtf4vsKk8r5PW5MnwS8DqZonP5eEbhW2OrX5ZsVyDT+Bqrf39p3kOyWYLXT2wA7y928g8FcXOZjwjTaWGWtA+BxAvbJgXhU9cl/y45kF69rfmc3uOQmeXpKNyOlTk6ipSrOfJkcHgNFFeLnxhJ7rYxpoXnxbObGhaNqn7gc5mt+ek+fwFzZ8j6QSKFsPr0NzwTFG80IbyiyrnC/MeRNh7SQFPAESIEP8LK3PoNx2l1M+MjCQXsb4oIG2oYYMRa2yx8qZ3npUOzMYOkJFY1uI/UEE/j/PlQSzMHfpmWus4o2sijfr8OmVPGeoU/UnVPyINqHhyAd1d3Iji3y3LMVemHtp5wVcuswABC7IRVVKZYrMCXMiycY5n00ch6XTaXBwCY00y8B3Mzkd7Ofq98YHc= (none)"
    ];
    # passwordFile = config.sops.secrets.misterio-password.path;
    packages = [ pkgs.home-manager ];
  };
}
