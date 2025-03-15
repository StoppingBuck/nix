{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      <home-manager/nixos>
      ./common.nix
      ./home-manager.nix
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
  services.locate.enable = true;
  services.locate.package = pkgs.mlocate;
  services.locate.localuser = null;

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
  environment.variables.GNOME_SHELL_EXTENSIONS = "appindicator"; # Not sure if this is actually needed or not
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  services.printing.enable = true; # Enable CUPS to print documents.

  environment.variables.EDITOR = "nvim";

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
