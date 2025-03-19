{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    <home-manager/nixos>
    
    # New organization
    ./modules/core.nix
    ./modules/gnome.nix
    ./modules/system-packages.nix
    ./modules/user.nix
    
    #TODO ?
    ./modules/hosts/desktop.nix
    
    # Home Manager will import its own sub-modules
    ./modules/hm/hm.nix
  ];

  system.stateVersion                 = "24.11";                      # Do not change this unless you want things to go wonky
  nix.settings.experimental-features  = [ "nix-command" "flakes" ];   #TODO Embrace the future
  nix.settings.show-trace             = false;                        #TODO Doesn't work
  nixpkgs.config.allowUnfree          = true;                         # Allow unfree packages for Nix system-level
  networking.hostName                 = "nixos-desktop";              #TODO Use special, see notes
  programs.hyprland.enable            = true;                         # Hyprland enabled as system package so it can integrate better
  services.dbus.enable                = true;                         # D-Bus is needed for notifications, waybar, etc.
  services.printing.enable            = true;                         # Enable CUPS to print documents.

  # Move Firefox cache to RAM to speed it up
  fileSystems."/home/mpr/.mozilla/firefox/cache" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "size=512M" "mode=1777" ];
  };
  # Use ZRAM for faster reads - compress Firefox’s memory pages, reducing disk reads.
  zramSwap.enable         = true;
  zramSwap.memoryPercent  = 50;
}
