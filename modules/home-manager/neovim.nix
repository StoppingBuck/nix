{ pkgs, lib, ...}:

let
  fromGitHub = ref: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
    };
  };
in

{
    packages = with pkgs; [
      lua-language-server
      nil
    ];
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      plugins = with pkgs.vimPlugins; [
        gruvbox-material
	nvim-treesitter.withAllGrammars
	plenary-nvim
        fzf-lua
        gitsigns-nvim
        lush-nvim
        neodev-nvim
        nvim-bqf
        nvim-lspconfig
        nvim-lspconfig
        nvim-treesitter-context
        nvim-treesitter-refactor
        nvim-treesitter-textobjects
        plantuml-syntax
        vim-nix
        which-key-nvim
        (fromGitHub "HEAD" "echasnovski/mini.nvim")
        (fromGitHub "HEAD" "levouh/tint.nvim")
        (fromGitHub "HEAD" "sam4llis/nvim-lua-gf")
        (fromGitHub "HEAD" "stevearc/oil.nvim")
        (fromGitHub "HEAD" "nat-418/boole.nvim")
        (fromGitHub "HEAD" "nat-418/bufala.nvim")
        (fromGitHub "HEAD" "nat-418/scamp.nvim")
        (fromGitHub "HEAD" "nat-418/tabbot.nvim")
        (fromGitHub "HEAD" "nat-418/termitary.nvim")
      ];
    };
  };
}
