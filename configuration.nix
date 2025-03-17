{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      <home-manager/nixos>
      ./modules/home-manager/home-manager.nix
      ./modules/system/common.nix
	    ./modules/system/nvidia.nix
      ./modules/system/services.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];  #TODO Embrace the future
  nix.settings.show-trace = false;                                  #TODO Doesn't work

########
# Installing system packages
# As mentioned above, if you can see yourself using sudo or root in conjunction with a package, that's a good indication you should install it as a system package.
# These are installed by NixOS, they have nothing to do with home-manager and they are available for everyone using the system.
# Just like with the user packages installed by home-manager, system packages can be installed either unmanaged or managed (by NixOS).
#
# Installing system packages (unmanaged)
########
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme  # This is the default theme, you can install other themes if desired
    bat					        # Better cat
    btop				        # Better htop
    curl
    dua					        # Better du
    eza					        # Better ls
    fastfetch				    # Better neofetch
    fd					        # Better find
    fzf					        # Fuzzy finder for CLI
    git					
    gnome-shell-extensions
    gnome-tweaks			
    gnomeExtensions.appindicator	# For tray in GNOME
    gping				        # Better ping
    jq					        # Swiss army knife for JSON
    kitty				        # Minimal terminal
    neovim				      # CLI-based text editing
    pciutils				    # Provides 'lspci'
    platinum-searcher		# Better the_silver_searcher
    ripgrep 				    # Better grep
    unzip
    wget
    zellij				      # Better tmux
  ];

########
# Installing system packages and services (managed)
########

  networking.hostName = "nixos-desktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  users.users.mpr.shell = pkgs.zsh; # Make zsh the default shell. This is here, not in home-manager, because it requires root

  programs.zsh.enable = true;
  programs.hyprland.enable = false;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # GNOME
  services.xserver = {
	enable = false;  # Disable X11 as we use Wayland
	displayManager.gdm.enable = true; # Gnome Display Manager
	displayManager.gdm.wayland = true;  # Ensure GDM uses Wayland
	desktopManager.gnome.enable = true; # GNOME Shell
  };

  # Optionally, customize the cursor further (if using specific themes or sizes)
  environment.variables = {
    XCURSOR_SIZE = "48";   # Custom cursor size
    XCURSOR_THEME = "Adwaita";  # You can change to other themes like "Breeze", "Oxygen", etc.
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "mpr";
  services.udev.packages = [ pkgs.gnome-settings-daemon ];
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
