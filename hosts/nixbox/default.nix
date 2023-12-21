{ config, inputs, outputs, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/base.nix
    ../common/pkral.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.nur.nixosModules.nur
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