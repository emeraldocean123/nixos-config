{ config, pkgs, ... }:
{
  # Add ~/.local/bin to PATH for any HM user importing this
  home.sessionPath = [ "$HOME/.local/bin" ];
}
