{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # basics
    git
    curl
    wget
    unzip
    nano

    # diagnostics
    htop
    fastfetch

    # optional helpful tools
    pciutils
    usbutils
    lshw

    # graphics checkers (uncomment after install if you want)
    # mesa-demos   # provides glxinfo, glxgears
    # vulkan-tools # provides vulkaninfo
  ];
}
