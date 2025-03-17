{ pkgs, ... }: {
programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    #initExtraFirst = ;
    initExtra = ''
        # Word navigation: The art of jumping from word to the previous/next word in the terminal
        # Zsh has a braindead default word style where trying to word jumping this: foo-bar/baz.qux would jump "foo", "bar", "baz", "quz"
        # So we change to Bash style, which is more geared towards natural language, and jumps "foo-bar/baz.qux" in its entirety
        autoload -U select-word-style       # Load function for modifying word navigation
        select-word-style bash              # Have Zsh use the same word navigation as Bash
    
        # This tells Zsh that the key combination passed by the terminal (Kitty) should be interpreted as word jumping
        bindkey '\e[1;5C' forward-word  # Ctrl+Right
        bindkey '\e[1;5D' backward-word # Ctrl+Left
    '';
    enableCompletion = true;

    shellAliases = {
        ll = "ls -l";
        edit-config = "function _edit_config() { sudo nvim /etc/nixos/\${1}.nix; }; _edit_config";
        sudo-vscode = "sudo code --no-sandbox --user-data-dir=/root/.vscode-root";
        rebuild-nixos="sudo sh -c 'cd /etc/nixos && nixos-rebuild switch'";
    };
    
    history = {
        size = 10000;
        share = true;  # Share history across multiple terminals
        ignoreDups = true;
        ignoreAllDups = true; # Remove duplicates from history
        expireDuplicatesFirst = true;
        save = 5000;  # Reduce initial history loading
    };
    
};

programs.fzf = {
    enable = true;
    enableZshIntegration = true;
};

programs.starship = {
  enable = true;  # Aktiverer Starship
  enableZshIntegration = true;  # Integrerer det med Zsh
  settings = {
    # Tilpasning (valgfrit)
    add_newline = false;  # Undgå ekstra linjer i prompten
    format = "$username@$hostname $directory $git_branch $character";  # Minimal prompt
  };
};
}