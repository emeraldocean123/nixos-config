# MSI GE75 Raider specific packages (base packages are in shared/packages-base.nix)
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # KDE/Plasma-specific theming and integration
    kdePackages.breeze-icons
    kdePackages.breeze-gtk
    kdePackages.xdg-desktop-portal-kde

    # KDE QoL tools
    kdePackages.kdeconnect-kde
    kdePackages.spectacle
    kdePackages.dolphin
    kdePackages.gwenview

    # Gaming/GPU diagnostics
    mesa-demos  # glxinfo/glxgears
    nvtopPackages.full
  ];

  # Optional gaming stack (uncomment to enable)
  # programs.steam.enable = true;
  # hardware.steam-hardware.enable = true;
}
