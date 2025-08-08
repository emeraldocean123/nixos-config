{ config, lib, pkgs, ... }:

let
  themePath = ./jandedobbeleer.omp.json;

  # Build the bashrc text without any literal `${...}` so Nix won't try to interpolate it.
  bashrcText =
    builtins.replaceStrings ["__DOLLAR__"] ["$"] ''
      # Show fastfetch once per interactive shell
      if [[ $- == *i* ]]; then
        if command -v fastfetch >/dev/null 2>&1 && [ -z "__DOLLAR__{__FASTFETCH_SHOWN:-}" ]; then
          fastfetch || true
          export __FASTFETCH_SHOWN=1
        fi
      fi

      # Oh My Posh prompt (guard to avoid double init)
      if [ -z "__DOLLAR__{OMP_LOADED:-}" ] && command -v oh-my-posh >/dev/null 2>&1; then
        eval "$(oh-my-posh init bash --config "$HOME/.config/oh-my-posh/jandedobbeleer.omp.json")"
        export OMP_LOADED=1
      fi
    '';
in
{
  home.packages = with pkgs; [
    oh-my-posh
    fastfetch
  ];

  home.file.".config/oh-my-posh/jandedobbeleer.omp.json".source = themePath;

  programs.bash = {
    enable = true;
    bashrcExtra = bashrcText;
  };
}
