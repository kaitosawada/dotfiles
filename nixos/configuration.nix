# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./home-server.nix
  ];

  # sops-nix configuration
  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    age.keyFile = "/var/lib/sops-nix/key.txt";
    secrets.user-password.neededForUsers = true;
    secrets.caddy-cloudflare-token = {
      owner = "caddy";
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # TODO: マシンに依存
  networking.hostName = "EM680-nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "ja_JP.UTF-8";
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = [ pkgs.fcitx5-mozc ];
  };
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "jp106";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
      options = "terminate:ctrl_alt_bksp";
    };
    displayManager = {
      gdm.enable = true;
    };
  };

  services.displayManager = {
    defaultSession = "sway";
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kaitosawada = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "input"
      "video"
    ]; # Enable ‘sudo’ for the user.
    uid = 1000;
    home = "/home/kaitosawada";
    shell = pkgs.zsh;
    hashedPasswordFile = config.sops.secrets.user-password.path;
  };

  programs.firefox.enable = true;
  programs.neovim.enable = true;
  programs.zsh.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim
    git
    gh
    wget
    curl
    ghostty

    # https://nixos.wiki/wiki/Sway
    grim
    slurp
    wl-clipboard
    mako

    bitwarden-desktop
    wtype # for sending keystrokes on Wayland

    # linux
    gcc
    gnupg
    # zlib
    # bzip2
    # xz
    # readline
    # sqlite
    # openssl
    # libffi
    # ncurses
    # tk
    # gdbm
    # tcl
    # pkg-config
  ];

  system.stateVersion = "25.05";
}
