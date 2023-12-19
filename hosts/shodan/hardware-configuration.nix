{ config, lib, pkgs, inputs, modulesPath, ... }:
{
  imports = [
    inputs.hardware.nixosModules.lenovo-thinkpad-x1-extreme-gen2
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 2;
  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
    configurationLimit = 5;
    consoleMode = "max";
    #font = "${pkgs.powerline-fonts}/share/fonts/bdf/ter-powerline-x32n.bdf";
    #fontSize = 32;
  };

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "usbhid" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelParams = [ "msr.allow_writes=on" ];

  console = {
    earlySetup = true;
    packages = [ pkgs.powerline-fonts ];
    font = "ter-powerline-v32b";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/eb0816a2-9c8a-4947-b591-913b28d8a591";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/58EB-7ED5";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/f975f912-8c27-4155-aed5-79a02b90556a"; }];

  boot.initrd.luks.devices = {
    cryptkey = {
      device = "/dev/disk/by-uuid/f340be68-64e7-48c3-91f2-c621be34cca6";
    };

    cryptroot = {
      device = "/dev/disk/by-uuid/1794767a-28ef-482a-a66d-0c20268ee833";
      keyFile = "/dev/mapper/cryptkey";
    };

    cryptswap = {
      device = "/dev/disk/by-uuid/4f091ffd-3b78-4af0-949c-807eb4be6fee";
      keyFile = "/dev/mapper/cryptkey";
    };
  };


  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  #hardware.enableRedistributableFirmware = true;
  hardware = {

    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        #      linuxPackages.nvidia_x11.out
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
      driSupport = true;
      #driSupport32Bit = true;
      #    extraPackages32 = with pkgs; [
      #      linuxPackages.nvidia_x11.lib32
      #    ];
    };

    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      #package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        sync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
      modesetting.enable = true;
    };

    bluetooth.enable = true;
    pulseaudio = {
      enable = true;
      # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
      # Only the full build has Bluetooth support, so it must be selected here.
      package = pkgs.pulseaudioFull;
    };

  };

  services.tlp.enable = false;


}
