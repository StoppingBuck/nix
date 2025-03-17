{ config, pkgs, lib, ... }: {

     home.file.".config/hypr/hyprland.conf".text = ''
    # Monitors
    monitor=DP-1,1920x1080@144Hz,0x0,1
    monitor=HDMI-A-1,1920x1080@60Hz,1920x0,1

    # Keybindings
    bind=SUPER, RETURN, exec, kitty
    bind=SUPER, Q, killactive,
    bind=SUPER, D, exec, wofi -show drun
    bind=SUPER, F, fullscreen,
    bind=SUPER, V, togglefloating,
    bind=SUPER, SPACE, exec, swaylock

    # Move between workspaces
    bind=SUPER, 1, workspace, 1
    bind=SUPER, 2, workspace, 2
    bind=SUPER, 3, workspace, 3
    bind=SUPER, 4, workspace, 4

    # Move windows between workspaces
    bind=SUPER SHIFT, 1, movetoworkspace, 1
    bind=SUPER SHIFT, 2, movetoworkspace, 2
    bind=SUPER SHIFT, 3, movetoworkspace, 3
    bind=SUPER SHIFT, 4, movetoworkspace, 4

    # Status bar (Waybar)
    exec-once=waybar &

    # Notifications (Dunst)
    exec-once=dunst &

    # Wallpaper
    exec-once=swww init &
    exec-once=swww img ~/Pictures/wallpaper.jpg &
  '';

  home.file.".config/waybar/config".text = ''
    {
      "modules-left": ["hyprland/workspaces", "clock"],
      "modules-center": ["hyprland/window"],
      "modules-right": ["battery", "cpu", "memory", "network", "pulseaudio"]
    }
  '';

  home.file.".config/waybar/style.css".text = ''
    * {
      font-size: 14px;
      font-family: "JetBrainsMono Nerd Font";
    }
  '';

  home.file.".config/hypr/hyprlock.conf".text = ''
    general {
        grace = 2              # Time before requiring a password (seconds)
        hide_cursor = true     # Hide cursor on lock screen
        disable_loading_bar = false # Show loading animation
    }

    background {
        path = ~/Pictures/wallpaper.jpg  # Lock screen background image
        blur_passes = 3                 # Blur effect strength
        contrast = 0.8                   # Contrast adjustment
    }

    input-field {
        size = 200, 50                   # Width, height of password field
        outline_thickness = 5             # Border thickness
        dots_center = true                # Center dots in field
    }
  '';

}
