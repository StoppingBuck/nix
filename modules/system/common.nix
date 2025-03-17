{ config, pkgs, ... }:
{
  # Bootloader.
  boot.loader.systemd-boot.enable       = true;
  boot.loader.efi.canTouchEfiVariables  = true;

  # Enable networking
  networking.networkmanager.enable      = true;

  # Locale
  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_DK.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS                = "da_DK.UTF-8";
    LC_IDENTIFICATION         = "da_DK.UTF-8";
    LC_MEASUREMENT            = "da_DK.UTF-8";
    LC_MONETARY               = "da_DK.UTF-8";
    LC_NAME                   = "da_DK.UTF-8";
    LC_NUMERIC                = "da_DK.UTF-8";
    LC_PAPER                  = "da_DK.UTF-8";
    LC_TELEPHONE              = "da_DK.UTF-8";
    LC_TIME                   = "da_DK.UTF-8";
  };
  # Configure keymap in X11
  services.xserver.xkb = {
    layout  = "dk";
    variant = "";
  };
  console.keyMap = "dk-latin1"; # Configure console keymap

  # Sound with pipewire
  hardware.pulseaudio.enable  = false;
  security.rtkit.enable       = true;
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
  };

  # Allow unfree packages for Nix system-level
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11"; # Do not change this unless you want things to go wonky

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mpr = {
    isNormalUser      = true;
    description       = "Mads Peter Rommedahl";
    extraGroups       = [ "networkmanager" "wheel" ];
  }; 
}
