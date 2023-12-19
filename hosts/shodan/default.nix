{ pkgs, config, inputs, outputs, lib, ... }: {

  imports = [
    ./hardware-configuration.nix
    ../common/base.nix
    ../common/pkral.nix
    inputs.home-manager.nixosModules.home-manager
    outputs.nixosModules.settings
    ../common/river
  ];

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

  virtualisation.libvirtd = {
    enable = true;
  };

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
  };

  home-manager.users.${config.settings.username} = import ../../home/pkral.nix;

}
