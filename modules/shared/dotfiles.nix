## modules/shared/dotfiles.nix
# Shared user dotfiles: aliases and Oh My Posh theme symlink from dotfiles flake input
{ config, lib, pkgs, ... }:
{
  home.file = {
    ".bash_aliases".text = ''
      alias ll='ls -alF'
      alias la='ls -A'
    '';

    # Source the single theme JSON from the dotfiles flake input
    ".config/oh-my-posh/jandedobbeleer.omp.json".source =
      let
        # Resolve the nixos-config flake, then use its `dotfiles` input
        nixcfg = builtins.getFlake (toString ../..);
      in
        nixcfg.inputs.dotfiles.outPath + "/posh-themes/jandedobbeleer.omp.json";
  };
}
