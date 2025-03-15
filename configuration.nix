{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      <home-manager/nixos>
      ./common.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

########
# START -- Home Manager
########
# Home Manager is like Nix, but specifically for your /home
# It can be used to set dotfiles, user packages, etc.
########
  home-manager.users.mpr = { pkgs, ... }: {
    nixpkgs.config.allowUnfree = true; # Allow unfree packages for home-manager
    home.stateVersion = "24.11"; 

########
# Installing user packages
# 
# Installing user packages - that is, installing packages via home-manager - means making the packages available only to the specified user, and not system-wide.
# This is generally a good idea for any packages that do not need system-wide privileges, such as most UI-based applications. Keeping packages restricted to a user improves security.
# On the other hand, if you could see yourself running a package with sudo or as root - such as with a lot of CLI-based applications like zsh or vim - they should instead be installed as system packages
####
# Installing user packages (unmanaged)
#
# This approach is used if you want to install a user package, but don't need any special configuration or integration with the NixOS/Home Manager ecosystem. Home-manager doesn't care about these packages beyond installing them
# If in doubt, this is the place to use
########
    home.packages = with pkgs; [
      brave
      discord
      fractal
      keepassxc
      mpv
      neovim
      obsidian
      vscode
      youtube-music
    ];

########
# Installing user packages (managed)
# Use programs.<program>.enable if you want more advanced configuration and integration, such as configuring the program’s settings, applying security patches, or adjusting system settings specific to the application.
# This causes home-manager to take over managing the package and its options. For a list of available options, check https://home-manager-options.extranix.com
########
    programs.zsh = {
      enable = true;
      initExtra = "source ~/.p10k.zsh";
      enableCompletion = true;
      syntaxHighlighting.enable = true;
    
      shellAliases = {
       ll = "ls -l";
       update = "sudo nixos-rebuild switch";
      };
      history.size = 10000;

      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
          { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
        ];
      };
    };

########
# Configuration files - dotfiles
# Here, we can use Home Manager to setup files in ~/.config as we want.
# If we do not add them here, but add them manually, they are liable to disappear
# You can do stuff directly like this:
#
#    home.file.".config/mpv/mpv.conf".text = ''
#      loop-file=inf
#    '';
# 
# But if possible, it is more idiomatic to do it like this:
    programs.mpv.config = {
      "loop-file" = "inf";
    };
# Again, check https://home-manager-options.extranix.com to see what options are available

    programs.kitty.enable = true; # required for the default Hyprland config
    wayland.windowManager.hyprland.enable = true; # enable Hyprland

    wayland.windowManager.hyprland.settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, F, exec, firefox" 				# mod + F = firefox
	"$mod, Return, exec, kitty"				# mod + Enter = Terminal
        ", Print, exec, grimblast copy area"			# PrintScreen = grimblast copy area
	"$mod, code:1, workspace, 1"
        "$mod SHIFT, code:1, movetoworkspace, 1"
        "$mod, code:2, workspace, 2"
        "$mod SHIFT, code:2, movetoworkspace, 2"
        "$mod, code:3, workspace, 3"
        "$mod SHIFT, code:3, movetoworkspace, 3"
        "$mod, code:4, workspace, 4"
        "$mod SHIFT, code:4, movetoworkspace, 4"
        "$mod, code:5, workspace, 5"
        "$mod SHIFT, code:5, movetoworkspace, 5"
        "$mod, code:6, workspace, 6"
        "$mod SHIFT, code:6, movetoworkspace, 6"
        "$mod, code:7, workspace, 7"
        "$mod SHIFT, code:7, movetoworkspace, 7"
        "$mod, code:8, workspace, 8"
        "$mod SHIFT, code:8, movetoworkspace, 8"
        "$mod, code:9, workspace, 9"
        "$mod SHIFT, code:9, movetoworkspace, 9"
      ];
    wayland.windowManager.hyprland.plugins = [
     # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
     # "/absolute/path/to/plugin.so"
    ];
    };
    wayland.windowManager.hyprland.systemd.variables = ["--all"];

    home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };
  };

########
# END -- Home Manager
########

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
  services.locate.enable = true;
  services.locate.package = pkgs.mlocate;
  services.locate.localuser = null;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  users.users.mpr.shell = pkgs.zsh; # Make zsh the default shell
  programs.zsh.enable = true;
  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # GNOME
  services.xserver.displayManager.gdm.enable = true; # Gnome Display Manager
  services.xserver.desktopManager.gnome.enable = true; # GNOME Shell
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "mpr";
  services.udev.packages = [ pkgs.gnome-settings-daemon ];
  environment.variables.GNOME_SHELL_EXTENSIONS = "appindicator"; # Not sure if this is actually needed or not
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  services.printing.enable = true; # Enable CUPS to print documents.

########
# NVIDIA
########
  # Disable Nouveau. Might not be needed.
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.kernelParams = [ "nomodeset" "modprobe.blacklist=nouveau" ];

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  # Settings for NVidia graphics cards
  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Setting this to false ensures we don't use the NVidia open source kernel module (not to be confused with the independent third-party "nouveau" open source driver).
    # The NVidia open source kernel module is mainly relevant for data centers. It is not as good as the proprietary one.
    open = false;

    # Enable the Nvidia settings menu accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
}
