# All we need to live in the CLI. Shell, terminal, CLI-tools, etc.
{ pkgs, ... }: {
    programs.zsh = {
        enable                      = true;
        enableCompletion            = true;
        autosuggestion.enable       = true;
        syntaxHighlighting.enable   = true;
        #initExtraFirst             = ;
        initExtra                   = ''
            # Word navigation: The art of jumping from word to the previous/next word in the terminal
            # Zsh has a braindead default word style where trying to word jumping this: foo-bar/baz.qux would jump "foo", "bar", "baz", "quz"
            # So we change to Bash style, which is more geared towards natural language, and jumps "foo-bar/baz.qux" in its entirety
            autoload -U select-word-style       # Load function for modifying word navigation
            select-word-style bash              # Have Zsh use the same word navigation as Bash

            # This tells Zsh that the key combination passed by the terminal (Kitty) should be interpreted as word jumping
            bindkey '\e[1;5C' forward-word  # Ctrl+Right
            bindkey '\e[1;5D' backward-word # Ctrl+Left
        '';

        shellAliases = {
            ll                      = "ls -l";
            edit-config             = "function _edit_config() { sudo nvim /etc/nixos/\${1}.nix; }; _edit_config";
            sudo-vscode             = "sudo env WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR /etc/profiles/per-user/mpr/bin/code --no-sandbox --user-data-dir=/root/.vscode-root";
            rebuild-nixos = ''
                set -e  # Exit immediately if a command fails
                echo "Starting NixOS rebuild..."
    sudo nixos-rebuild switch

    echo "NixOS rebuild completed!"

    echo "Checking if we are in a Wayland session and if Hyprland is running..."
    echo "WAYLAND_DISPLAY: $WAYLAND_DISPLAY"
    echo "XDG_SESSION_TYPE: $XDG_SESSION_TYPE"

    if pgrep -fi Hyprland > /dev/null; then
        echo "Hyprland detected, attempting reload..."
        hyprctl reload
        pgrep waybar && pkill waybar
        waybar & disown
        pgrep mako && pkill mako
        mako & disown
        echo "Hyprland reload complete!"
    else
        echo "Hyprland is not running or detected under a different name. Skipping reload."
    fi
            '';
        };

        history = {
            size                    = 10000;
            share                   = true; # Share history across multiple terminals
            ignoreDups              = true;
            ignoreAllDups           = true; # Remove duplicates from history
            expireDuplicatesFirst   = true;
            save                    = 5000; # Reduce initial history loading
        };

    };

    programs.fzf = {
        enable = true;
        enableZshIntegration = true;
    };

    programs.starship = {
        enable                  = true;
        enableZshIntegration    = true;
        settings = {
            add_newline         = false;  # No unnecessary extra lines
            format              = "$username@$hostname $directory $git_branch $character";  # Minimal prompt
        };
    };

    programs.zoxide = {
        enable                  = true;
        enableZshIntegration    = true;
    };
}
