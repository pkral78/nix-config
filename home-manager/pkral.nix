{ pkgs, config, nixosConfig, inputs, outputs, lib, ... }:
let
  names = builtins.attrNames config;
in
{
  systemd.user.startServices = "sd-switch";

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  # programs.vscode = {
  #   enable = true;
  # };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    terminal = "tmux-256color";
    shortcut = "b";
    extraConfig = ''
      set -g mouse on
    '';
  };

  programs.ssh = {
    enable = true;
    forwardAgent = true;
    controlMaster = "auto";
    controlPath = "~/.ssh/master-%r@%n:%p";
    controlPersist = "10m";

    matchBlocks = {
      "photon" = {
        hostname = "photon.kralovi.net";
        user = "pkral";
      };
    };
  };

  programs.git = {
    enable = true;
    userName = nixosConfig.settings.name;
    userEmail = nixosConfig.settings.email;
    signing = {
      key = "7B88C3748C24D98B";
      signByDefault = false;
    };
    aliases = {
      s = "status -s -uno";
      gl = "log --oneline --graph";
      pullall = "!git pull --rebase && git submodule update --init --recursive";
    };
    ignores = [ ".#*" "*.desktop" ];
    extraConfig = {
      branch.autosetuprebase = "never";
      push.default = "simple";
      gc.autoDetach = false;
      core = {
        autocrlf = "input";
        symlinks = true;
        longpaths = true;
      };
      http.sslVerify = false;
      log = { date = "format:%Y-%m-%d %H:%M"; };
      format = {
        pretty =
          "format:%C(auto,yellow)%h%C(auto,magenta)% G? %C(auto,blue)%>(16,trunc)%ad %C(auto,green)%<(32,trunc)%ae%C(auto,reset)%s%C(auto,red)% gD% D";
      };

    };
  };

  programs.zsh = rec {
    enable = true;
    #    enableAutosuggestions = false;
    # enabled by oh-my-zsh, this only ensure that compinit is not called twice
    enableCompletion = false;
    dotDir = ".config/zsh";
    history = {
      size = 10000000;
      save = 10000000;
      path = "$HOME/.config/zsh/.zsh_history";
      expireDuplicatesFirst = true;
      share = true;
      extended = true;
    };

    #    envExtra = ''
    #    ZSH=$ZDOTDIR/oh-my-zsh
    #    '';

    initExtraBeforeCompInit = ''
      source $ZDOTDIR/.shared.zshrc
    '';

    #    plugins = [
    #    ];

    #    oh-my-zsh = {
    #      enable = true;
    #      plugins = ["autojump" "colored-man-pages" "git" "gitignore" "sudo" "docker" "kubectl"];
    #      theme = "agnoster";
    #    };

    shellAliases = {
      "ll" = "ls -al";
      "ns" = "nix-shell --command zsh";
      "hh" = "hstr";
      "tx" = "tmuxinator";
    };

    initExtra = ''
      # hstr
      setopt hist_expire_dups_first
      setopt hist_ignore_all_dups
      setopt hist_ignore_space
      setopt hist_no_store
      setopt hist_reduce_blanks
      setopt share_history
      setopt magicequalsubst
      bindkey -s "\C-r" "\C-a hstr -- \C-j"
      export HSTR_CONFIG=hicolor
      export HISTFILE=$HISTFILE
    '';

    /* initExtra = let
       cdpath = "$HOME/src" +
       optionalString (config.settings.profile != "malloc47")
       " $HOME/src/${config.settings.profile}";
       in
       ''
       hg() { history | grep $1 }
       pg() { ps aux | grep $1 }

       function chpwd() {
       emulate -L zsh
       ls
       }

       cdpath=(${cdpath})
       '';
    */

    sessionVariables = {
      #      EDITOR = "vim";
      #      HSTR_CONFIG="hicolor";
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=10";
    };
  };

  home.file = {
    ".config/zsh/.shared.zshrc" = {
      text = ''
              # OVerriden gnome-keyring ssh-agent https://github.com/NixOS/nixpkgs/issues/101616
              export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

              ANTIBODY_HOME="$(antibody home)"
              ZSH_THEME="agnoster"

              plugins=(
                autojump
                colored-man-pages
                docker
                git
                gitignore
                kubectl
                sudo
              )

              export ZSH="$ANTIBODY_HOME/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh"

              # quit bugging me!
              DISABLE_AUTO_UPDATE="true"

              # omz!
              source <(antibody init)
              antibody bundle "
                robbyrussell/oh-my-zsh
                zsh-users/zsh-completions
                spwhitt/nix-zsh-completions
                zdharma/fast-syntax-highlighting
                b4b4r07/enhancd
                #ellie/atuin
              "

              # enhancd is not antibody "native", must be sourced explicitly
              export ENHANCD_FILTER=fzf
              source `antibody path b4b4r07/enhancd`/init.sh

              # TODO Tilda incompatability?
              # marzocchi/zsh-notify

              setopt auto_cd
              unsetopt correct_all
              setopt no_flow_control

              __enhancd::filter::exists()
        {
            local line

            while read line
            do
                if [[ $line == /mnt/* || -d $line ]]; then
                    echo "$line"
                fi
            done
        }
      '';
    };

    ".config/river/init".source = ../home/.config/river/init;
    ".config/kanshi/config".source = ../home/.config/kanshi/config;
    #
  };

  home = {
    # TODO check config what contains
    #username = builtins.trace "Debug: ${builtins.toJSON names}" nixosConfig.settings.username;
    username = nixosConfig.settings.username;
    homeDirectory = "/home/${config.home.username}";
    # TODO inherit from system
    #stateVersion = lib.mkDefault "23.05";
    stateVersion = nixosConfig.settings.stateVersion;

    # stateVersion = system.stateVersion;
    #stateVersion = outputs.nixosConfigurations.${config.settings.hostname}.config.system.stateVersion;
    # stateVersion = current.config.system.stateVersion;
  };

  home.packages = with pkgs; [
    #alacritty
    antibody
    autojump
    azure-cli
    #brave
    cntr
    cloud-utils
    #discord
    distrobox # Nice escape hatch, integrates docker images with my environment
    docker-compose
    exiftool
    #feh
    ffmpeg
    #firefox
    #google-chrome
    gopass
    hstr
    ispell
    #libreoffice-fresh
    ltex-ls # Spell checking LSP
    nil
    pdftk
    pv
    #remmina
    #slack
    #sqlitebrowser
    #sublime-merge-dev
    #tdesktop
    #thunderbird
    #tilda
    #tk
    tmuxinator
    #virt-manager
    #vlc
    wine
    #wireshark
    zim
  ];


  # home.pointerCursor = {
  #   gtk.enable = true;
  #   package = pkgs.bibata-cursors;
  #   name = "Bibata-Modern-Ice";
  #   size = 22;
  # };

  #   xsession = {
  #   enable = true;
  #   pointerCursor = {
  #     size = 40;
  #     package = nixosConfig.nur.repos.humxc.fluent-cursors-theme;
  #     name = "Vimix-white-cursors";
  #     # name = "Vimix-cursors";

  #     # package = pkgs.capitaine-cursors;
  #     # name = "capitaine-cursors";

  #     # package = pkgs.nur.repos.ambroisie.volantes-cursors;
  #     # name = "volantes_light_cursors";
  #     # name = "volantes_cursors";

  #     # package = pkgs.nur.repos.dan4ik605743.lyra-cursors;
  #     # name = "LyraF-cursors";
  #   };
  # };

}

# config:
# ["_module","accounts","assertions","dconf","editorconfig","fonts","gtk","home","home-files","i18n","launchd","lib","manual","meta","news","nix","nixpkgs","pam","programs","qt","services","specialisation","specialization","submoduleSupport","systemd","targets","warnings","wayland","xdg","xfconf","xresources","xsession"]
