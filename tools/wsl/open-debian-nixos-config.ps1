param(
  [string]$Dir = "~/projects/nixos-config"
)

# Launch Debian WSL in target directory
& wsl.exe -d Debian --cd $Dir

