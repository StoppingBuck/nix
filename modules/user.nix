# This is my user. Create it, permission it, set correct locale, etc.
{ config, pkgs, lib, ... }:

{
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.mpr = {
        isNormalUser    = true;
        description     = "Mads Peter Rommedahl";
        extraGroups     = [ "networkmanager" "wheel" ];
    }; 

    programs.zsh.enable     =  true;    # Needed because we set mpr's default shell to zsh.
    users.users.mpr.shell   = pkgs.zsh; # Make zsh the default shell. This is here, not in home-manager, because it requires root

    # Locale
    console.keyMap              = "dk-latin1";          # Configure console keymap
    time.timeZone               = "Europe/Copenhagen";
    i18n.defaultLocale          = "en_DK.UTF-8";
    i18n.extraLocaleSettings    = {
      LC_ADDRESS                = "da_DK.UTF-8";
      LC_IDENTIFICATION         = "da_DK.UTF-8";
      LC_MEASUREMENT            = "da_DK.UTF-8";
      LC_MONETARY               = "da_DK.UTF-8";
      LC_NAME                   = "da_DK.UTF-8";
      LC_NUMERIC                = "da_DK.UTF-8";
      LC_PAPER                  = "da_DK.UTF-8";
      LC_TELEPHONE              = "da_DK.UTF-8";
      LC_TIME                   = "da_DK.UTF-8";
    };
    services.xserver.xkb = {
        layout  = "dk";
        variant = "";
    };
}
