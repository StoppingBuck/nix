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
    dig                 # Provides 'dig', 'nslookup' and related commands
    dua					        # Better du
    eza					        # Better ls
    fastfetch				    # Better neofetch
    fd					        # Better find
    git					
    gnome-shell-extensions
    gnome-tweaks			
    gnomeExtensions.appindicator	# For tray in GNOME
    gping				        # Better ping
    jq					        # Swiss army knife for JSON
    mpd
    neovim				      # CLI-based text editing
    pciutils				    # Provides 'lspci'
    platinum-searcher		# Better the_silver_searcher
    python3
    ripgrep 				    # Better grep
    unzip
    wget
    zellij				      # Better tmux

    # Hyprland-related apps
    hyprland            # Core
    wireplumber                 # needed for screensharing
    xdg-desktop-portal-hyprland # needed for screensharing

    #TODO: hardware acceleration for firefox on Nvidia. Move to a better spot?
    nvidia-vaapi-driver # VA-API support for NVIDIA
    libva               # VA-API (Video Acceleration API) library
    libva-utils         # Debugging tool for VA-API
    libvdpau            # VDPAU (Video Decode and Presentation API for UNIX)
    vdpauinfo           # Debugging tool for VDPAU
  ];

########
# Installing system packages and services (managed)
########
  #programs.hyprland = {
  #  enable = true;
   # xwayland.enable = true;
  #};
  networking.hostName = "nixos-desktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  users.users.mpr.shell = pkgs.zsh; # Make zsh the default shell. This is here, not in home-manager, because it requires root

  programs.zsh.enable = true;
  programs.hyprland.enable = true;
   
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";  # Enable Wayland support for Electron apps
    QT_QPA_PLATFORM = "wayland";  # Ensure Qt apps use Wayland
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland,x11";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # GNOME
  services.xserver = {
	  enable = false;  # Disable X11 as we use Wayland
	  displayManager.gdm = {
      enable  = true; # Gnome Display Manager
      wayland = true; # Ensure GDM uses Wayland
      autoLogin.delay = 5;
    };
	  desktopManager.gnome.enable = true; # GNOME Shell
  };

  # Optionally, customize the cursor further (if using specific themes or sizes)
  environment.variables = {
    XCURSOR_SIZE = "48";   # Custom cursor size
    XCURSOR_THEME = "Adwaita";  # You can change to other themes like "Breeze", "Oxygen", etc.

    LIBVA_DRIVER_NAME = "nvidia";
    VDPAU_DRIVER = "nvidia";
    MOZ_DISABLE_RDD_SANDBOX = "1";  # Nødvendigt for at VA-API virker i Firefox
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "mpr";
  services.udev.packages = [ pkgs.gnome-settings-daemon ];
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
