{ lib, pkgs, ... }:
let
  themePath = builtins.toString ./jandedobbeleer.omp.json;
in {
  programs.bash.enable = true;

  programs.bash.bashrcExtra = ''
    # ==== Unified prompt (fastfetch + Oh My Posh) ====
    # Interactive shells only
    if [[ "''${-}" == *i* ]]; then
      # fastfetch once per shell
      if command -v fastfetch >/dev/null 2>&1 && [ -z "''${FASTFETCH_ONCE:-}" ]; then
        fastfetch || true
        export FASTFETCH_ONCE=1
      fi

      # oh-my-posh once per shell
      if command -v oh-my-posh >/dev/null 2>&1 && [ -z "''${OMP_LOADED:-}" ]; then
        eval "$(oh-my-posh init bash --config ${themePath})"
        export OMP_LOADED=1
      fi
    fi
  '';
}
