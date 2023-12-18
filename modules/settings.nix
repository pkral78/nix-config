{ config, pkgs, lib, ... }:
with lib;
{
  options = {
    settings = {
      name = mkOption {
        default = "Pavel Král";
        type = with types; uniq str;
      };
      username = mkOption {
        default = "pkral";
        type = with types; uniq str;
      };
      stateVersion = mkOption {
        default = "23.11";
        type = with types; uniq str;
      };
      email = mkOption {
        default = "pavel.kral@gmail.com";
        type = with types; uniq str;
      };
      vm = mkOption {
        type = types.bool;
        default = false;
      };
      terminal = mkOption {
        default = "alacritty";
        type = with types; uniq str;
      };
      fontName = mkOption {
        default = "Inconsolata";
        type = with types; uniq str;
      };
      fontSize = mkOption {
        default = 12;
        type = types.int;
      };
      profile = mkOption {
        default = "pkral78";
        type = with types; uniq str;
        description = ''
          Profiles are a higher-level grouping than hosts. They are
          useful to combine multiple related things (e.g. ssh keys)
          that should be available on multiple hosts.
        '';
      };
      xkbFile = mkOption {
        default = "none";
        type = with types; uniq str;
        description = ''
          Filename of the xkb file to load (or "none" if no keyboard
          layout is desired). File is specified without extension and
          must be present in the xkb directory.
        '';
      };
    };
  };
}
