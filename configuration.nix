{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      <home-manager/nixos>
      ./common.nix
      ./home-manager.nix
#      ./hyprland.nix
      ./nvidia.nix
      ./services.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

########
# Installing system packages
# As mentioned above, if you can see yourself using sudo or root in conjunction with a package, that's a good indication you should install it as a system package.
# These are installed by NixOS, they have nothing to do with home-manager and they are available for everyone using the system.
# Just like with the user packages installed by home-manager, system packages can be installed either unmanaged or managed (by NixOS).
#
# Installing system packages (unmanaged)
########
  environment.systemPackages = with pkgs; [
    fastfetch
    git
    gnome-tweaks
    gnomeExtensions.appindicator
    kitty
    pciutils
    platinum-searcher
    wget
  ];

########
# Installing system packages and services (managed)
########

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  users.users.mpr.shell = pkgs.zsh; # Make zsh the default shell
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  programs.neovim.viAlias = true;
  programs.neovim.vimAlias = true;


  programs.zsh.enable = true;
  programs.hyprland.enable = false;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # GNOME
  services.xserver.displayManager.gdm.enable = true; # Gnome Display Manager
  services.xserver.desktopManager.gnome.enable = true; # GNOME Shell
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "mpr";
  services.udev.packages = [ pkgs.gnome-settings-daemon ];
#  environment.variables.GNOME_SHELL_EXTENSIONS = "appindicator"; # Not sure if this is actually needed or not
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  environment.variables.EDITOR = "nvim";

}
