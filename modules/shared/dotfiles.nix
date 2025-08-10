## modules/shared/dotfiles.nix
# Shared user dotfiles: aliases and Oh My Posh theme symlink from dotfiles flake input
{ config, lib, pkgs, dotfiles, ... }:
{
  home.file = {
    ".bash_aliases".text = ''
      alias ll='ls -alF'
      alias la='ls -A'
    '';

    # Source the single theme JSON from the injected dotfiles flake input
    ".config/oh-my-posh/jandedobbeleer.omp.json".source =
      dotfiles.outPath + "/posh-themes/jandedobbeleer.omp.json";
  };
}
