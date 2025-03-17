{ config, pkgs, lib, ... }:

{

########
# Home Manager is like Nix, but specifically for your /home
# It can be used to set dotfiles, user packages, etc.
########
  home-manager.users.mpr = { pkgs, ... }: {

    imports = [
      #./home/neovim.nix
      ./zsh.nix
      #./home/xdg.nix
      #./home/git.nix
      #./home/packages.nix
      #./home/applications.nix
    ];

    nixpkgs.config.allowUnfree = true; # Allow unfree packages for home-manager
    home.stateVersion = "24.11";

    home.sessionVariables = {
    };
    xdg.enable = false;
    xdg.userDirs.enable = true;
    xdg.userDirs.music="/home/mpr/pCloudDrive/mp/music";

#The reason you sometimes have home. and sometimes not is because Home Manager has its own namespace.
#
#How It Works:
#Everything under home. is a Home Manager option.
#Things outside of home. (like programs.tealdeer) are specific modules within Home Manager.


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
      chatgpt-cli
      discord
      fractal
      keepassxc
      mpv
      obsidian
      ventoy
      vscode
      youtube-music
    ];

########
# Installing user packages (managed)
# Use programs.<program>.enable if you want more advanced configuration and integration, such as configuring the program’s settings, applying security patches, or adjusting system settings specific to the application.
# This causes home-manager to take over managing the package and its options. For a list of available options, check https://home-manager-options.extranix.com
########

    programs.tealdeer = {
      enable = true;
      settings = {
        auto_update = true;
      };
    };

    

########
# Configuration files - dotfiles
# Here, we can use Home Manager to setup files in ~/.config as we want.
# If we do not add them here, but add them manually, they are liable to disappear
# You can do stuff directly like this:
#
    home.file.".config/mpv/mpv.conf".text = ''
      loop-file=inf
    '';
# 
# But if possible, it is more idiomatic to do it like this:
#    programs.mpv.config = {
#      loop-file = "inf";
#    };
# Again, check https://home-manager-options.extranix.com to see what options are available

    programs.kitty.enable = true; # required for the default Hyprland config


  };
}
