{ config, lib, pkgs, ... }:

let
  themePath = ./jandedobbeleer.omp.json;
in
{
  # Make sure we have the tools available at the user level
  home.packages = with pkgs; [
    oh-my-posh
    fastfetch
  ];

  # Ensure the OMP theme is present in the user's config dir
  home.file.".config/oh-my-posh/jandedobbeleer.omp.json".source = themePath;

  programs.bash = {
    enable = true;

    # Keep this tiny and robust: no "else", clean guards
    bashrcExtra = ''
      # Show fastfetch once per interactive shell
      if [[ $- == *i* ]]; then
        if command -v fastfetch >/dev/null 2>&1 && [ -z "${__FASTFETCH_SHOWN:-}" ]; then
          fastfetch || true
          export __FASTFETCH_SHOWN=1
        fi
      fi

      # Oh My Posh prompt (guard to avoid double init)
      if [ -z "${OMP_LOADED:-}" ] && command -v oh-my-posh >/dev/null 2>&1; then
        eval "$(oh-my-posh init bash --config "$HOME/.config/oh-my-posh/jandedobbeleer.omp.json")"
        export OMP_LOADED=1
      fi
    '';
  };
}
