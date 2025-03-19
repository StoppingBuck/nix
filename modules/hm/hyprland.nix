{ config, pkgs, lib, ... }: {

  programs.wofi = {
    enable = true;
    settings = {
      width = "50%";          # Adjust width
      height = "50%";         # Adjust height
      hide_search = false;    # Show search bar
      insensitive = true;     # Case-insensitive search
      allow_markup = true;    # Enable markup in results
    };
  };

  home.file.".config/hypr/hyprland.conf".text = ''

input {
    kb_layout = dk
    kb_options = grp:alt_shift_toggle
}

    # Monitors
    # Force monitor positions
    exec-once=hyprctl keyword monitor DVI-D-1,1920x1080@60Hz,0x0,1
    exec-once=hyprctl keyword monitor HDMI-A-1,1920x1080@60Hz,1920x0,1

    # Keybindings
    bind=SUPER, RETURN, exec, kitty
    bind=SUPER, Q, killactive,
    bind=SUPER, D, exec, wofi --show drun
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
    "layer": "top",
    "position": "top",
    "height": 38,
    "spacing": 10,

    "modules-left": [
        "hyprland/workspaces",
        "hyprland/window"
    ],

    "modules-center": [
        "clock"
    ],

    "modules-right": [
        "cpu",
        "memory",
        "temperature",
        "network",
        "wireplumber",
        "tray"
    ],

    "clock": {
        "format": "{:%A, %d %B %H:%M}",
        "tooltip-format": "<big>{:%Y-%m-%d %H:%M:%S}</big>",
        "format-alt": "{:%Y-%m-%d %H:%M}"
    },

    "cpu": {
        "format": " {usage}%",
        "tooltip": false
    },

    "memory": {
        "format": " {used:0.1f}GB",
        "tooltip": false
    },

    "temperature": {
        "thermal-zone": 2,
        "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
        "format": " {temperatureC}°C"
    },

    "network": {
        "format-wifi": " {essid} ({signalStrength}%)",
        "format-ethernet": " {ipaddr}/{cidr}",
        "tooltip": true,
        "format-disconnected": "⚠ Disconnected"
    },

    "wireplumber": {
        "format": "{volume}% {icon}",
        "format-muted": " Muted",
        "tooltip": false,
        "scroll-step": 5,
        "on-click": "pavucontrol",
        "icons": {
            "default": ["", ""]
        }
    },

    "tray": {
        "icon-size": 16,
        "spacing": 10
    }
}
'';

  home.file.".config/waybar/style.css".text = ''
* {
    font-family: "JetBrainsMono Nerd Font", "FontAwesome";
    font-size: 14px;
    border: none;
}

window#waybar {
    background: rgba(30, 30, 46, 0.9);
    border-bottom: 2px solid rgba(80, 80, 100, 0.8);
    color: #cdd6f4;
}

#clock {
    color: #89b4fa;
    font-weight: bold;
}

#network {
    color: #fab387;
}

#wireplumber {
    color: #f5e0dc;
}

#cpu, #memory, #temperature {
    color: #f9e2af;
}

#workspaces button {
    padding: 5px;
    margin: 2px;
    border-radius: 5px;
    background: transparent;
    color: #cdd6f4;
}

#workspaces button.active {
    background: #89b4fa;
    color: #1e1e2e;
}

#workspaces button:hover {
    background: #b4befe;
    color: #1e1e2e;
}
'';

  # Declaratively set the Wofi theme
  home.file.".config/wofi/style.css".text = ''
    window {
        margin: 5px;
        border: 2px solid #89b4fa;
        background-color: #1e1e2e;
    }

    #entry {
        padding: 5px;
        background-color: #313244;
        color: #cdd6f4;
    }

    #entry:selected {
        background-color: #89b4fa;
        color: #1e1e2e;
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
