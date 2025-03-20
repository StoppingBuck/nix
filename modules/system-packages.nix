{ config, pkgs, lib, ... }:

{
    environment.systemPackages = with pkgs; [
        #neovim				      # CLI-based text editing
        python3
        efibootmgr          # For mangling your /boot

        # CLI commands
        curl
        dig             # Provides 'dig', 'nslookup', etc.
        file            # Provides 'file'
        git
        jq			    # Swiss army knife for JSON
        unzip
        wget

        # Improvements on coreutils
        bat					# Provides 'bat'        - a better cat
        btop				# Provides 'btop'       - a better htop
        dua					# Provides 'dua'        - a better du
        eza					# Provides 'eza'        - a better ls
        fastfetch			# Provides 'fastfetch'  - a better neofetch
        fd					# Provides 'fd'         - a better find
        gping				# Provides 'gping'      - a better ping
        platinum-searcher   # Provides 'pt'         - a better ag
        ripgrep 			# Provides 'rg'         - a better grep
        zellij				# Provides 'zellij'     - a better tmux
        zoxide              # Provides 'z'          - a better cd

        # Utils
        pciutils				    # Provides 'lspci'
        usbutils            # Provides 'lsusb'

        # Hyprland-related utils
        pavucontrol
        kitty
        wofi
        wireplumber                 # needed for screensharing
        xdg-desktop-portal-hyprland # needed for screensharing
        xdg-desktop-portal-wlr

        # GNOME-related utils
        adwaita-icon-theme  # This is the default theme, you can install other themes if desired
        gnome-shell-extensions
        gnome-tweaks			
        gnomeExtensions.appindicator	# For tray in GNOME

        # Hardware acceleration for firefox on Nvidia #TODO Not needed on laptop?
        ffmpeg
        libva               # VA-API (Video Acceleration API) library
        libva-utils         # Debugging tool for VA-API
        libvdpau            # VDPAU (Video Decode and Presentation API for UNIX)
        nvidia-vaapi-driver # VA-API support for NVIDIA
        vdpauinfo           # Debugging tool for VDPAU

        capitaine-cursors
        bibata-cursors

        libnotify # Good for notify-send debugging

        # Hyprland
        grimblast   # Screenshot tool
        hypridle    # Auto-locking the screen
        hyprlock    # Lock screen
        hyprpaper   # Wallpaper daemon
        waybar      # Status bar
        wlogout     #TODO ??

        yazi  # File navigation in CLI
        ueberzugpp  # Enables image previews
        ffmpegthumbnailer  # Video thumbnails
        poppler  # PDF previews
        exiftool  # Metadata previews

        go
    ];

    fonts.enableDefaultPackages = true;
    environment.variables = {
      XCURSOR_THEME = "Capitaine Cursors";  # Change based on what you install
      XCURSOR_SIZE = "24";
    };


    fonts.packages = with pkgs; [
      nerdfonts
      font-awesome
      noto-fonts
      noto-fonts-emoji
    ];
}