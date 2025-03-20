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
    networking.enableIPv6 = false;

# Force NetworkManager to use only static DNS
networking.networkmanager.dns = "systemd-resolved";
# Override NetworkManager to ignore DNS from DHCP
environment.etc."NetworkManager/conf.d/dns.conf".text = ''
  [main]
  dns=systemd-resolved

  [global-dns]
  servers=1.1.1.1,8.8.8.8

  [global-dns-domain-*]
  servers=1.1.1.1,8.8.8.8

  [connection]
  ignore-auto-dns=true
'';

# Ensure systemd-resolved is enabled
services.resolved.enable = true;
services.resolved.extraConfig = ''
  DNS=1.1.1.1 8.8.8.8
  Domains=~.
  DNSSEC=no
  MulticastDNS=no
  LLMNR=no
  Cache=no
  DNSStubListener=no
  FallbackDNS=
  UseDNS=no
'';

    # Setup Wayland and GDM as display manager    
    environment.sessionVariables = {
        GDK_BACKEND = "wayland,x11";
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";  # Enable Wayland support for Electron apps
        QT_QPA_PLATFORM = "wayland";  # Ensure Qt apps use Wayland
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        XDG_SESSION_TYPE = "wayland";
        XKB_DEFAULT_LAYOUT = "dk";
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

    security.wrappers.sudo = {
        setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.sudo}/bin/sudo";
        permissions = lib.mkForce "u+rx,g+x,o+x";  # Force overwrite the default NixOS module with the same value to avoid conflicts
    };

    environment.etc."sudoers.d/wayland".text = ''
        Defaults env_keep += "WAYLAND_DISPLAY XDG_RUNTIME_DIR"
        Defaults env_keep += "DBUS_SESSION_BUS_ADDRESS"
    '';

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
        audio.enable = true;
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
