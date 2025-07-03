# modules/common.nix
# Shared configuration for all hosts

{
  # Enable modern Nix CLI and flakes support for all hosts
  nix.settings.extra-experimental-features = [ "nix-command" "flakes" ];

  # Common system packages (example)
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
  ];

  # Timezone and locale
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  # Common user configuration (replace with your actual user)
  users.users.joseph = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  # Enable NetworkManager service globally (optional if per-host override)
  networking.networkmanager.enable = true;
}
