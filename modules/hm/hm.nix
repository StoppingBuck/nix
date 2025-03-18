{ config, pkgs, lib, ... }:

{
########
# Home Manager is like Nix, but specifically for your /home
# It can be used to set dotfiles, user packages, etc.
########
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.mpr = { pkgs, ... }: {

    imports = [
      #./home/neovim.nix
      ./cli.nix
      ./hyprland.nix
      ./user-packages.nix
    ];

    home.stateVersion = "24.11";
    nixpkgs.config.allowUnfree = true;  # Gør det eksplicit for Home Manager

    #TODO ONLY the Hyprland on Hyprland?
    home.sessionVariables = {
      XDG_SESSION_TYPE = "wayland";
      #XDG_CURRENT_DESKTOP = "Hyprland";
      #XDG_SESSION_DESKTOP = "Hyprland";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      CLUTTER_BACKEND = "wayland";
      SDL_VIDEODRIVER = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
    };
    xdg.enable          = false; #TODO ?
    xdg.userDirs.enable = true;
    xdg.userDirs.music  ="/home/mpr/pCloudDrive/mp/music";

    #The reason you sometimes have home. and sometimes not is because Home Manager has its own namespace.
    #
    #How It Works:
    #Everything under home. is a Home Manager option.
    #Things outside of home. (like programs.tealdeer) are specific modules within Home Manager.

    home.packages = with pkgs; [
      brave
      chatgpt-cli
      discord
      fractal
      keepassxc
      ncmpcpp
      obsidian
      vscode
      youtube-music
      youtube-tui
      #ytui-music
      zsh-fzf-tab

      # Hyprland
      dunst       # Notification daemon
      grim        # Screenshot tool
      hypridle    # Auto-locking the screen
      hyprlock    # Lock screen
      hyprpaper   # Wallpaper daemon
      #mako        # Notifikationer (Wayland) #TODO This AND dunst?
      slurp       # Select region for screenshot
      waybar      # Status bar
      wlogout     #TODO ??
      wofi        # App launcher
      
      
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

    programs.firefox = {
      enable = true;
      policies = {
        DisableTelemetry = false;           # I don't trust Mozilla not to be idiots, but I do trust them not to be evil
        DisablePocket = false;              # I actually want to use Pocket. L'horreur!
        DisableFirefoxStudies = true;       # No more Mr. Robot
        DisableSponsoredTiles = true;       # TODO ???
        DisableFormHistory = true;          # More of a hassle than it should be
        NoDefaultBookmarks = true;          # No "Mozilla" bookmarks or other bollocks
        OfferToSaveLogins = false;          # Go away, I use KeePass
        SearchBar = "hidden";               # I use an omnibar
        UserMessaging = {                   # Suppressing a bunch of situations where Firefox would say "Hey, we have this great thing..."
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          FirefoxLabs = false;
          MoreFromMozilla = false;
          SkipOnboarding = true;
          WhatsNew = false;
        };
      };
    };
    #programs.defaultBrowser = "firefox"; #TODO What is the correct approach?

    ########
    # Configuration files - dotfiles
    # Here, we can use Home Manager to setup files in ~/.config as we want.
    # If we do not add them here, but add them manually, they are liable to disappear
    ########
    programs.mpv = {
      enable = true;
      scripts = [
        (pkgs.stdenv.mkDerivation {
          pname = "mpv-autoload";
          version = "1.0";

          # Save the script as a file instead of letting Nix try to unpack something
          src = pkgs.writeText "autoload.lua" ''
            local options = {
              disabled = false,
              shuffle = false
            }

            local msg = require "mp.msg"
            local utils = require "mp.utils"
            local loaded = false

            function add_files()
              if options.disabled or loaded then return end
              loaded = true

              local path = mp.get_property("path", "")
              if not path or path == "" then return end

              local dir, filename = utils.split_path(path)
              local files = utils.readdir(dir, "files")

              if not files then return end

              table.sort(files)
              local playlist = {}
              local current_index = nil

              for i, file in ipairs(files) do
                  local ext = file:match("%.([^%.]+)$")
                  if ext and (ext == "mkv" or ext == "mp4" or ext == "avi" or ext == "mov" or ext == "mp3" or ext == "flac" or ext == "gif" or ext == "png" or ext == "jpg" or ext == "jpeg" or ext == "flv") then
                      local filepath = utils.join_path(dir, file)
                      table.insert(playlist, filepath)
                      if file == filename then
                          current_index = #playlist
                      end
                  end
              end

              if not current_index then return end

              local reordered_playlist = {}
              for i = current_index, #playlist do
                  table.insert(reordered_playlist, playlist[i])
              end
              for i = 1, current_index - 1 do
                  table.insert(reordered_playlist, playlist[i])
              end

              for i, file in ipairs(reordered_playlist) do
                  if i == 1 then
                      mp.commandv("loadfile", file, "replace")
                  else
                      mp.commandv("loadfile", file, "append-play")
                  end
              end

              mp.unregister_event(add_files)
              msg.info("Playlist reordered: " .. #reordered_playlist .. " files. Starting from: " .. filename)
              end

              mp.register_event("file-loaded", add_files)
          '';

          dontUnpack    = true; # We are writing directly to a file so no unpacking
          installPhase  = ''
            mkdir -p $out/share/mpv/scripts
            cp $src $out/share/mpv/scripts/autoload.lua
          '';

          scriptName = "autoload.lua";
        })
      ];
    };
    #TODO Nixyfy this
    home.file.".config/mpv/mpv.conf".text = ''
      fs-screen=current
      fullscreen=yes
      loop-file=inf
      image-display-duration=inf  # Forces MPV to keep playing image files instead of treating them as a single frame, this allowing autoload to work
    '';

    programs.kitty = {
      enable = true;
      extraConfig = ''
        map ctrl+left send_text all \x1b[1;5D
        map ctrl+right send_text all \x1b[1;5C
      '';
    };
  };
}