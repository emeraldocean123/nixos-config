# /etc/nixos/home/hp-dv9500-pavilion-nixos/joseph.nix
# Home Manager configuration for user 'joseph' on HP dv9500 Pavilion (2007, AMD Turion 64 X2, NVIDIA GeForce 7150M)

{ config, pkgs, ... }:

{
  # Set the username and home directory for this Home Manager profile
  home.username = "joseph";
  home.homeDirectory = "/home/joseph";
  home.stateVersion = "25.05";

  # Essential packages including Oh My Posh and development tools
  home.packages = with pkgs; [
    # System packages
    dconf
    
    # Development tools
    git
    curl
    wget
    unzip
    nano
    
    # Shell enhancement
    oh-my-posh
    fzf
  ];

  # Configure bash with dotfiles-style configuration
  programs.bash = {
    enable = true;
    
    # History settings
    historyControl = [ "ignoreboth" ];
    historySize = 1000;
    historyFileSize = 2000;
    
    # Shell options
    shellOptions = [
      "histappend"
      "checkwinsize"
    ];
    
    # Custom aliases (matching dotfiles)
    shellAliases = {
      ll = "ls -lah";
      la = "ls -A";
      l = "ls -CF";
      gs = "git status";
      ".." = "cd ..";
      
      # Enable color support
      ls = "ls --color=auto";
      grep = "grep --color=auto";
    };
    
    # Bash functions (matching dotfiles)
    bashrcExtra = ''
      # fzf functions
      ff() { find . -type f | fzf; }
      fd() { find . -type d | fzf | xargs -r cd; }
      
      # Oh My Posh prompt
      if command -v oh-my-posh &> /dev/null; then
        eval "$(oh-my-posh init bash --config ${pkgs.oh-my-posh}/share/oh-my-posh/themes/jandedobbeleer.omp.json)"
      fi
    '';
  };

  # Git configuration (matching dotfiles)
  programs.git = {
    enable = true;
    userName = "Joseph";
    userEmail = "emeraldocean123@users.noreply.github.com";
  };

  # Enable other CLI programs
  programs.htop.enable = true;
  programs.fastfetch.enable = true;
  
  # Enable fzf for fuzzy finding
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  # GTK theming for user applications (matches system theming)
  gtk = {
    enable = true;
    theme.name = "Arc-Dark";
    iconTheme.name = "Papirus";
  };

  # Optional: Create dotfiles symlinks for external compatibility
  # This allows the bootstrap script to work if needed
  home.file = {
    ".bash_aliases".text = ''
      alias gs='git status'
      alias ll='ls -lah'
      alias ..='cd ..'
    '';
    
    ".gitconfig".text = ''
      [user]
      	name = Joseph
      	email = emeraldocean123@users.noreply.github.com
    '';
  };
}
