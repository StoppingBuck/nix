{ config, pkgs, lib, ... }: {

  home.file.".config/kitty/kitty.conf".text = ''
    confirm_os_window_close 0
  ''; 

  home.file.".config/hypr/hyprland.conf".text = ''

input {
    kb_layout = dk
    kb_options = grp:alt_shift_toggle
}

exec-once = sleep 2 && gtk-launch pcloud

    # Cursors
    env = XCURSOR_THEME,capitaine-cursors
    env = XCURSOR_SIZE,24

    # Force monitor positions and bind workspaces
    #TODO Crappy hack. Fix it
    # DVI-D-1 = Left monitor
    # HDMI-A-1 = Right monitor
    exec-once=hyprctl keyword monitor DVI-D-1,1920x1080@60Hz,0x0,1
    exec-once=hyprctl keyword monitor HDMI-A-1,1920x1080@60Hz,1920x0,1
    workspace=1,monitor:DVI-D-1
    workspace=2,monitor:HDMI-A-1
    workspace=3,monitor:HDMI-A-1
    workspace=4,monitor:HDMI-A-1
    workspace=5,monitor:DVI-D-1

    # Keybindings:
    # SUPER + Enter = terminal
    # SUPER + Q = close app
    # SUPER + D = app launcher
    # SUPER + F = fullscreen mode
    # SUPER + V = Toggle floating window
    # SUPER + SHIFT + S = Screenshot
    # SUPER + SPACE = Lock screen
    
    bind=SUPER, RETURN, exec, kitty
    bind=SUPER, Q, killactive,
    bind=SUPER, D, exec, wofi --show drun
    bind=SUPER, F, fullscreen,
    bind=SUPER, V, togglefloating,
    bind=SUPER SHIFT, S, exec, grimblast copysave area ~/Pictures/Screenshots/
    bind=SUPER, SPACE, exec, hyprlock

    # Move focus between windows using SUPER + arrow or hjkl
    bind=SUPER, Left, movefocus, l
    bind=SUPER, Right, movefocus, r
    bind=SUPER, Up, movefocus, u
    bind=SUPER, Down, movefocus, d
    bind=SUPER, H, movefocus, l
    bind=SUPER, L, movefocus, r
    bind=SUPER, K, movefocus, u
    bind=SUPER, J, movefocus, d

    # Swaps places with the next window in focus.
    bind=SUPER SHIFT, Left, swapwindow, l
    bind=SUPER SHIFT, Right, swapwindow, r
    bind=SUPER SHIFT, Up, swapwindow, u
    bind=SUPER SHIFT, Down, swapwindow, d

    # Move focus between workspaces with SUPER + [1-5]
    bind=SUPER, 1, workspace, 1
    bind=SUPER, 2, workspace, 2
    bind=SUPER, 3, workspace, 3
    bind=SUPER, 4, workspace, 4
    bind=SUPER, 5, workspace, 5

    # Move windows between workspaces with SUPER + SHIFT + [1-5]
    bind=SUPER SHIFT, 1, movetoworkspace, 1
    bind=SUPER SHIFT, 2, movetoworkspace, 2
    bind=SUPER SHIFT, 3, movetoworkspace, 3
    bind=SUPER SHIFT, 4, movetoworkspace, 4
    bind=SUPER SHIFT, 5, movetoworkspace, 5

    # Move to next/previous workspace dynamically
    #TODO Duplicate bindings. Find something else
    #bind=SUPER SHIFT, Left, movetoworkspace, -1
    #bind=SUPER SHIFT, Right, movetoworkspace, +1

    # Move workspaces between monitors
    #TODO Doesn't work
    bind=SUPER, O, moveworkspacetomonitor, next
    
    # Move current windows between monitors
    #TODO Doesn't work
    #bind=SUPER, Shift, O, movewindow, mon:next

    # Resize floating window with arrow keys (i3-style)
    bind=SUPER ALT, Left, resizeactive, -40 0
    bind=SUPER ALT, Right, resizeactive, 40 0
    bind=SUPER ALT, Up, resizeactive, 0 -40
    bind=SUPER ALT, Down, resizeactive, 0 40

    # Use 'scratchpad' workspace
    bind=SUPER SHIFT, 0, movetoworkspace, special
    bind=SUPER, 0, togglespecialworkspace

    # Mouse bindings:
    # Drag a floating window with SUPER + left mouse button
    # Resize floating window with SUPER + right mouse button
    bindm = SUPER, mouse:273, resizewindow
    bindm = SUPER, mouse:272, movewindow

    # Status bar (Waybar)
    exec-once=waybar &
  '';

   home.file.".config/mpd/mpd.conf".text = ''
        music_directory    "~/pCloudDrive/mp/music"
        db_file           "~/.config/mpd/tag_cache"
        state_file        "~/.config/mpd/state"

        audio_output {
            type "pipewire"
            name "PipeWire Sound Server"
        }

        db_file "/home/mpr/.config/mpd/tag_cache"  # Store DB in user dir
        state_file "/home/mpr/.config/mpd/state"  # Store state in user dir

        # Increase buffer size to prevent stuttering
        audio_buffer_size "4096"

        # Disable Avahi
        zeroconf_enabled "no"
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
        "locale": "da_DK.UTF-8",
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
        "ignore-missing": true,
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
