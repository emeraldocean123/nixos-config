{ lib, pkgs, ... }:
let
  # Use the theme that lives in this repo; read it from the Nix store at runtime
  themePath = builtins.toString ./jandedobbeleer.omp.json;
in {
  programs.bash.enable = true;

  programs.bash.bashrcExtra = ''
    # ==== Unified prompt (fastfetch + Oh My Posh) ====

    # Only for interactive shells
    case "$-" in
      *i*)
        # Show fastfetch once per shell
        if command -v fastfetch >/dev/null 2>&1 && [ -z "''\${__FASTFETCH_SHOWN:-}" ]; then
          fastfetch || true
          export __FASTFETCH_SHOWN=1
        fi

        # Init Oh My Posh (use our repo theme directly from the Nix store)
        if command -v oh-my-posh >/dev/null 2>&1 && [ -z "''\${__OMP_LOADED:-}" ]; then
          eval "$(oh-my-posh init bash --config ${themePath})"
          export __OMP_LOADED=1
        fi
        ;;
    esac
  '';
}
