{ config, inputs, outputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common/base.nix
    ../common/pkral.nix
    ../common/global/acme.nix
    ../common/services/nginx.nix
    ./services/headscale.nix
    inputs.home-manager.nixosModules.home-manager
    outputs.nixosModules.settings
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  networking = {
    hostName = "contabo";
    domain = "";
    enableIPv6 = false;
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
  programs.ssh.startAgent = true;

  #users.users.root.openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCRX/fQGNyRZ4TMwm2a1xSfV/6xQalYRoawu8det/Ypss9CZILtg9GGdgCPsTBKu7vqFcmoPp870yPVhZ0S8g3xEKLK+GQNDRdHScBaAy+cuaph9QxMJ0n3qnf3+HOF1Pzsb+n0eAJ7WGQ88r8vAC7pOWmXUpJVaW+DzTuK8+hfeyjoaUqmK+z6IVZ+JAPbK6N9vBo9AHdzHEhmpuMVuz7LQ9HKwSPiOA9rlI0g1EmA7Dm3hIJaf2sFdXC2lNTQCVX9+4pYUEeqywf6hF1DZ7jwLEjFa7Uw853W57M+lGEyPWMZ373DYZaI92I7qGVFoTuvzbCVWv+/wgFPTcq4G83T /home/pkral/.ssh/wintermute-rsa.openssh.prv'' ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPi+YHT3MbhW5zSmPx0cq2PmsxW3cHT427cMNBLoVP+V wintermute-key-231008'' ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDFVGGrpuKfLtgRcU1Eong2wTxW8NhRq9Lu/Oi+O2QDuXkaGDsU+AeLGE3bvfrO/4qBEk0Y/McRtccmA4mlEkVKq3Ou/GEZOPRBZQrIKxQYitIQ2LpsVnaUTqiHNn8MyfG0XDr1ItarMutVmaheH32oCWEba+2bxMsAZhCcJhd2YiDYFWW630rQVgsD8n/hOdax32JQrqaGOtfsYEiqz5VgJK6ZWvOUTUQMIO89N/nBTcfWUMa0UKXqZ3kZoDXjz5XUcG9XRG1bRJWN573c+sisfvHSxIUbjyepI5v+BNBQZWeIZtjBS0iJNRgiU1PjmdetOBuCo6rUnlcvaLKSwEE9I1SFo8dbFvt4K7NsZ3bR210+HN+Fs2/BfEvYhm+NrIpDiVmgMnLf8/2kQGiCjWSZ/z4aj+4G19xhQ4tbrWEeaMWYwaa4roMbD3SmmKG288033KFRLXe8e1klZv6ydkAdOK7vQOiVnUYKbM+sRHmipPcOxGa3t4ciL0hPvoRMv4kScKr68aqBWRDyX3uwpXl9PEAEuVwbBcdOgKD/1BzjbhHKLzHD/30r5seK/W1/dh0euONP79vjDOavhplSkj+OA7Mf22ogkfFoB2jbvqikbRhSQTc/RGLoSywjZKMMOUw4xCDFsxRMimR3+7Gq3VT3g1dKEmvTVAYiuZT5qcVNBw==" ];

  system.stateVersion = config.settings.stateVersion;

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
  };

  home-manager.users.${config.settings.username} = import ../../home-manager/pkral.nix;
}
