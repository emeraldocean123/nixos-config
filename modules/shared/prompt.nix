## modules/shared/prompt.nix
# Initializes Oh My Posh prompt in bash via Home Manager
{ pkgs, ... }:
{
  programs.bash = {
    # Ensure login shells source interactive config
    profileExtra = ''
      if [ -r "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
      fi
    '';
  # Interactive shells: show fastfetch and set prompt
  bashrcExtra = ''
      if command -v fastfetch >/dev/null 2>&1; then
        if [ -z "${FASTFETCH_RAN:-}" ]; then
          fastfetch
          export FASTFETCH_RAN=1
        fi
      fi
      if command -v oh-my-posh >/dev/null 2>&1; then
        eval "$(oh-my-posh init bash --config $HOME/.config/oh-my-posh/jandedobbeleer.omp.json)"
      fi
    '';
  };
}
