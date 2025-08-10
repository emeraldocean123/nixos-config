## modules/shared/prompt.nix
# Initializes Oh My Posh prompt in bash via Home Manager
{ pkgs, ... }:
{
  programs.bash = {
  # Leave profileExtra empty to avoid double-sourcing .bashrc on systems
  # where login shells already source it via global profile.
  profileExtra = ''
  '';
  # Interactive shells: show fastfetch once per TTY and set prompt
  bashrcExtra = ''
      # Only in interactive shells
      case $- in *i*) interactive=1 ;; *) interactive=0 ;; esac
      if [ "$interactive" = 1 ]; then
        # Determine a per-TTY marker path to avoid duplicate banners
        TTY_PATH="$(tty 2>/dev/null)" || TTY_PATH=""
        if printf '%s' "$TTY_PATH" | grep -q '^/'; then
          TTY_NAME="$(printf '%s' "$TTY_PATH" | sed 's:.*/::')"
        else
          TTY_NAME=""
        fi
        UID_NUM="$(id -u 2>/dev/null)"
        if [ -n "$XDG_RUNTIME_DIR" ]; then
          RUNTIME_DIR="$XDG_RUNTIME_DIR"
        else
          RUNTIME_DIR="/run/user/$UID_NUM"
        fi
        MARKER="$RUNTIME_DIR/fastfetch-shown.${TTY_NAME:-unknown}"
        if [ -n "$TTY_NAME" ] && [ ! -f "$MARKER" ]; then
          if command -v fastfetch >/dev/null 2>&1; then
            fastfetch
          fi
          mkdir -p "$RUNTIME_DIR" 2>/dev/null || true
          : > "$MARKER" 2>/dev/null || true
        fi
        if command -v oh-my-posh >/dev/null 2>&1; then
          eval "$(oh-my-posh init bash --config $HOME/.config/oh-my-posh/jandedobbeleer.omp.json)"
        fi
      fi
    '';
  };
}
