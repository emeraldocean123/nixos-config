## home/shared/user-base.nix
# Base Home Manager configuration shared by all users
{pkgs, ...}: {
  imports = [
    ../../modules/shared/prompt.nix
    ../../modules/shared/path-localbin.nix
    ../../modules/shared/dotfiles.nix
    ../../modules/shared/cleanup.nix
  ];

  # Common packages for all users
  home.packages = with pkgs; [
    dconf
    git
    curl
    wget
    unzip
    nano
    oh-my-posh
    fzf
    htop
    fastfetch
  ];

  # Common program configurations (grouped to avoid repeated keys)
  programs = {
    bash = {
      enable = true;
      # Aliases and PATH handled via shared modules
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
    };

    htop.enable = true;
    fastfetch.enable = true;
  };

  home.stateVersion = "25.05";
}
