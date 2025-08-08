{ config, pkgs, lib, ... }:

let
  # Home Manager gives us this; default for safety if not present
  homeDir  = config.home.homeDirectory or "/home/joseph";
  dotfiles = "${homeDir}/dotfiles";
  ompTheme = "${config.xdg.configHome or "${homeDir}/.config"}/oh-my-posh/jandedobbeleer.omp.json";
in {
  # Make sure these are available
  home.packages = with pkgs; [ oh-my-posh fastfetch ];

  # Share DOTFILES path across sessions
  home.sessionVariables.DOTFILES = dotfiles;

  programs.bash = {
    enable = true;
    initExtra = ''
      # --- fastfetch (only once per shell) ---
      if [[ $- == *i* ]] && command -v fastfetch >/dev/null 2>&1; then
        if [[ -z "$__FASTFETCH_SHOWN" ]]; then
          fastfetch || true
          export __FASTFETCH_SHOWN=1
        fi
      fi

      # --- Oh My Posh ---
      if command -v oh-my-posh >/dev/null 2>&1; then
        if [[ -f "${ompTheme}" ]]; then
          eval "$(oh-my-posh init bash --config '${ompTheme}')"
        else
          eval "$(oh-my-posh init bash)"
        fi
      fi

      # Handy git helpers
      gs(){ git status; }
      gl(){ git --no-pager log --oneline -n 20; }
      gd(){ git --no-pager diff; }
    '';
  };

  # Ensure the theme file is present (pulls from your flake repo)
  home.file.".config/oh-my-posh/jandedobbeleer.omp.json".source =
    ../../modules/shared/jandedobbeleer.omp.json;
}
