## modules/shared/prompt.nix
# Initializes Oh My Posh prompt in bash via Home Manager
{...}: {
  programs.bash = {
    # Show fastfetch on login shells once per session (guarded by env var)
    profileExtra = ''
      # Only in interactive bash login shells
      case $- in *i*) interactive=1 ;; *) interactive=0 ;; esac
      if [ "$interactive" = 1 ] && shopt -q login_shell; then
        if [ -z "''${NO_FASTFETCH:-}" ] && [ -z "''${FASTFETCH_SHOWN:-}" ] && command -v fastfetch >/dev/null 2>&1; then
          fastfetch || true
        fi
        export FASTFETCH_SHOWN=1
      fi
    '';
    # Interactive shells: show fastfetch once per session and set prompt
    bashrcExtra = ''
      # Only in interactive shells
      case $- in *i*) interactive=1 ;; *) interactive=0 ;; esac
      if [ "$interactive" = 1 ]; then
        if [ -z "''${NO_FASTFETCH:-}" ] && [ -z "''${FASTFETCH_SHOWN:-}" ] && command -v fastfetch >/dev/null 2>&1; then
          fastfetch || true
          export FASTFETCH_SHOWN=1
        fi
        if command -v oh-my-posh >/dev/null 2>&1; then
          eval "$(oh-my-posh init bash --config $HOME/.config/oh-my-posh/jandedobbeleer.omp.json)"
        fi
      fi
    '';
  };
}
