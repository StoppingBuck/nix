{ pkgs, ... }: {
    programs.zsh = {
      enable = true;
      initExtra = "source ~/.p10k.zsh";
      enableCompletion = true;
      syntaxHighlighting.enable = true;
    
      shellAliases = {
      ll = "ls -l";
      "edit-config" = "function _edit_config() { sudo nvim /etc/nixos/\${1}.nix; }; _edit_config";
      sudo-vscode = "sudo code --no-sandbox --user-data-dir=/root/.vscode-root";

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
}