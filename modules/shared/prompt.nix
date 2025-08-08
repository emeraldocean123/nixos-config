{ config, lib, pkgs, ... }:

let
  themePath = ./jandedobbeleer.omp.json;
in
{
  home.packages = with pkgs; [
    oh-my-posh
    fastfetch
  ];

  home.file.".config/oh-my-posh/jandedobbeleer.omp.json".source = themePath;

  programs.bash = {
    enable = true;

    # Keep this tiny; no ${...}, no nested ifs.
    bashrcExtra = ''
      # show fastfetch once per interactive shell
      if [ -z "$__FASTFETCH_SHOWN" ] && [ -n "$PS1" ]; then
        if command -v fastfetch >/dev/null 2>&1; then
          fastfetch || true
          export __FASTFETCH_SHOWN=1
        fi
      fi

      # oh-my-posh init (guarded)
      if [ -z "$OMP_LOADED" ] && command -v oh-my-posh >/dev/null 2>&1; then
        eval "$(oh-my-posh init bash --config "$HOME/.config/oh-my-posh/jandedobbeleer.omp.json")"
        export OMP_LOADED=1
      fi
    '';
  };
}
