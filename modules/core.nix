{ config, pkgs, lib, ... }:

# This is for core setup.
# Without this you can't see shit, you can't hear shit, you can't do shit
#
# That means:
# I. Bootloader
# II, Display Manager (GDM)
# III. Sound (PipeWire)
# IV. Networking
{

    # Bootloader.
    boot.loader.efi.efiSysMountPoint = "/boot"; # Sørg for at efi partitionen er korrekt monteret
    boot.loader.efi.canTouchEfiVariables  = true;
    boot.loader.systemd-boot.enable       = true;
    boot.loader.systemd-boot.configurationLimit = 5;
    boot.loader.timeout = 5; # 5 sekunder før den booter ind i default OS

    # Windows øverst #TODO desktop only
    boot.loader.systemd-boot.extraEntries = {
        "00-windows.conf" = ''
          title Windows
          efi /EFI/Microsoft/Boot/bootmgfw.efi
        '';
    };

    # Enable networking
    networking.networkmanager.enable    = true;

    # Setup Wayland and GDM as display manager    
    environment.sessionVariables = {
        GDK_BACKEND = "wayland,x11";
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";  # Enable Wayland support for Electron apps
        QT_QPA_PLATFORM = "wayland";  # Ensure Qt apps use Wayland
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        XDG_SESSION_TYPE = "wayland";
    };
    services.xserver = {
	    enable                      = false;    # Disable X11 as we use Wayland
        desktopManager.gnome.enable = true;     # GNOME Shell
	    displayManager.gdm = {
            enable                  = true;     # Gnome Display Manager
            wayland                 = true;     # Ensure GDM uses Wayland
            autoLogin.delay         = 5;
        };
    };
    services.displayManager.autoLogin.enable    = true;
    services.displayManager.autoLogin.user      = "mpr";
    services.udev.packages                      = [ pkgs.gnome-settings-daemon ]; #TODO ???
    # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    systemd.services."getty@tty1".enable        = false;
    systemd.services."autovt@tty1".enable       = false;

    # Sound with PipeWire
    hardware.pulseaudio.enable                  = false;
    security.rtkit.enable                       = true;
    services.pipewire = {
      enable                                    = true;
      alsa.enable                               = true;
      alsa.support32Bit                         = true;
      pulse.enable                              = true;
      #extraConfig.pipewire."92-low-latency" = {
      #  context.properties = {
      #    "default.clock.rate"                  = 48000;
      #    "default.clock.quantum"               = 1024;
      #    "default.clock.min-quantum"           = 1024;
      #    "default.clock.max-quantum"           = 1024;
      #  };
      #};
      #extraConfig.pipewire-pulse = {
      #  "pulse.properties" = {
      #    "session.suspend-timeout-seconds"     = 0;  # Disable auto-suspend
      #  };
      #};
    };

    services.locate = {
        enable = true;
        package = pkgs.plocate;
        localuser = null;
    };
}