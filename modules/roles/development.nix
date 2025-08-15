# modules/roles/development.nix
# Development role - programming tools, editors, and development environments
{ config, pkgs, ... }:
{
  # Development packages
  environment.systemPackages = with pkgs; [
    # Editors and IDEs
    vscode
    vim
    nano
    
    # Version control
    git
    git-lfs
    github-cli
    
    # Programming languages and runtimes
    nodejs
    python3
    rustc
    cargo
    go
    
    # Build tools and package managers
    gnumake
    cmake
    gcc
    pkg-config
    
    # Development utilities
    curl
    wget
    jq
    tree
    ripgrep
    fd
    bat
    eza
    
    # Container and virtualization tools
    docker
    docker-compose
    
    # Network tools
    nmap
    netcat
    wireshark
    
    # Database tools
    sqlite
    postgresql
    
    # Documentation and markdown
    pandoc
    
    # System monitoring and debugging
    strace
    gdb
    valgrind
  ];

  # Enable Docker
  virtualisation.docker.enable = true;
  
  # Add users to docker group (handled in shared/users.nix if needed)
  # users.users.joseph.extraGroups = [ "docker" ];
  
  # Git configuration (global defaults)
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  # Enable development-friendly services
  services = {
    # Enable SSH for remote development
    openssh.enable = true;
    
    # Enable development databases (optional - uncomment if needed)
    # postgresql.enable = true;
    # redis.servers."".enable = true;
  };

  # Development-specific environment variables
  environment.variables = {
    EDITOR = "code";
    BROWSER = "brave";
  };
}