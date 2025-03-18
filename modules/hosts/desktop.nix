{ config, pkgs, lib, ... }:

{
    # Fixes scratchy sound due to internal sound card being constantly turned on and off
    boot.kernelModules                  = [ "snd_hda_intel" ];
    
    boot.kernelParams                   = [
      "snd_hda_intel.power_save=0"
      "snd_hda_intel.power_save_controller=N"
    ];

    ########
    # NVIDIA
    ########
    # Disable Nouveau. Might not be needed.
    boot.blacklistedKernelModules       = [ "nouveau" ];

    # Enable OpenGL
    hardware.graphics.enable            = true;

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers       = ["nvidia"];

    # Settings for NVidia graphics cards
    hardware.nvidia = {
        modesetting.enable              = true;

        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        # Enable this if you have graphical corruption issues or application crashes after waking
        # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
        # of just the bare essentials.
        powerManagement.enable          = false;
        
        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer).
        powerManagement.finegrained     = false;
        
        # Setting this to false ensures we don't use the NVidia open source kernel module (not to be confused with the independent third-party "nouveau" open source driver).
        # The NVidia open source kernel module is mainly relevant for data centers. It is not as good as the proprietary one.
        open                            = false;

        # Enable the Nvidia settings menu accessible via `nvidia-settings`.
        nvidiaSettings                  = true;

        # Optionally, you may need to select the appropriate driver version for your specific GPU.
        package                         = config.boot.kernelPackages.nvidiaPackages.latest;
    };
}