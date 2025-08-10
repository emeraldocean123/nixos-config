## modules/shared/prompt.nix
# Initializes Oh My Posh prompt in bash via Home Manager
{ pkgs, ... }:
{
  programs.bash = {
  # Leave profileExtra empty to avoid double-sourcing .bashrc on systems
  # where login shells already source it via global profile.
  profileExtra = ''
  '';
  # Interactive shells: show fastfetch and set prompt
  bashrcExtra = ''
  # Only in interactive shells
  case $- in *i*) interactive=1 ;; *) interactive=0 ;; esac
  if [ "$interactive" = 1 ] && command -v fastfetch >/dev/null 2>&1; then
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
