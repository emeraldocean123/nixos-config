## modules/shared/path-localbin.nix
# Ensure ~/.local/bin is on PATH via bash init
{ ... }:
{
  programs.bash.initExtra = ''
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
      export PATH="$HOME/.local/bin:$PATH"
    fi
  '';
}
