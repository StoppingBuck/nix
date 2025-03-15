{ config, pkgs, lib, ... }:

{

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
      "edit-config" = "function _edit_config() { sudo nvim /etc/nixos/\${1}.nix; }; _edit_config";

      # Rebuild NixOS
      rebuild-nixos="sudo sh -c 'cd /etc/nixos && nixos-rebuild switch'";

      # Flake rebuild (if you use flakes)
      "rebuild-flake" = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";

      # Change directory to /etc/nixos
      "cd-nixos" = "cd /etc/nixos";
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

    programs.neovim = {
  viAlias = true;
  vimAlias = true;
  extraConfig = ''
    set number relativenumber
  '';
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
    wayland.windowManager.hyprland.enable = false; # enable Hyprland

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

}
