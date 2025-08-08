{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    oh-my-posh
    fastfetch
  ];
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      if [ -z "$__FASTFETCH_SHOWN" ] && [ -n "$PS1" ]; then
        if command -v fastfetch >/dev/null 2>&1; then
          fastfetch || true
          export __FASTFETCH_SHOWN=1
        fi
      fi
      if [ -z "$OMP_LOADED" ] && command -v oh-my-posh >/dev/null 2>&1; then
        eval "$(oh-my-posh init bash --config "$HOME/.config/oh-my-posh/jandedobbeleer.omp.json")"
        export OMP_LOADED=1
      fi
    '';
  };
}
