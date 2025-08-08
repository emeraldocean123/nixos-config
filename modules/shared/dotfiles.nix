{ config, lib, pkgs, ... }:
{
  home.file = {
    ".bash_aliases".source = ./bash_aliases;
    ".config/oh-my-posh/jandedobbeleer.omp.json".source = ./jandedobbeleer.omp.json;
  };
}
