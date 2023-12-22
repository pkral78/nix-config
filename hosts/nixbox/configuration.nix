{ config, inputs, outputs, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./vbox-fix.nix
    ../common/base.nix
    ../common/pkral.nix
    inputs.home-manager.nixosModules.home-manager
    outputs.nixosModules.settings
    ../common/river
  ];

  # Enable sound.
  sound.enable = true;
  sound.mediaKeys.enable = true;

  system.stateVersion = config.settings.stateVersion;

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
  };

  home-manager.users.${config.settings.username} = import ../../home/pkral.nix;
}