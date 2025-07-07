# /etc/nixos/modules/shared/dotfiles.nix
# Shared dotfiles configuration for all hosts
# This module manages common dotfiles using Home Manager

{ config, pkgs, ... }:

{
  # Git configuration
  programs.git = {
    enable = true;
    userName = "Joseph";
    userEmail = "emeraldocean123@users.noreply.github.com";
    
    extraConfig = {
      # Core settings
      core = {
        editor = "nano";
        autocrlf = "input";
      };
      
      # Push settings
      push = {
        default = "simple";
      };
      
      # Pull settings
      pull = {
        rebase = false;
      };
      
      # Color settings
      color = {
        ui = true;
        branch = "auto";
        diff = "auto";
        status = "auto";
      };
      
      # Init settings
      init = {
        defaultBranch = "main";
      };
    };
    
    # Common Git aliases
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      ca = "commit -a";
      cam = "commit -a -m";
      cm = "commit -m";
      lg = "log --oneline --graph --decorate";
      last = "log -1 HEAD";
      unstage = "reset HEAD --";
      visual = "!gitk";
    };
  };

  # Bash configuration
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
      "autocd"
      "globstar"
    ];
    
    # Environment variables
    sessionVariables = {
      EDITOR = "nano";
      BROWSER = "firefox";
      PAGER = "less";
    };
    
    # Shell aliases
    shellAliases = {
      # Basic aliases
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      
      # Directory navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      
      # Git shortcuts
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      gb = "git branch";
      gco = "git checkout";
      
      # System shortcuts
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      
      # NixOS specific
      nrs = "sudo nixos-rebuild switch";
      nrt = "sudo nixos-rebuild test";
      nrb = "sudo nixos-rebuild boot";
      nfu = "nix flake update";
      
      # Directory shortcuts
      docs = "cd ~/Documents";
      down = "cd ~/Downloads";
      desk = "cd ~/Desktop";
      
      # Safety nets
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";
      
      # Utilities
      h = "history";
      j = "jobs -l";
      path = "echo -e \${PATH//:/\\\\n}";
      now = "date +\"%T\"";
      nowtime = "date +\"%d-%m-%Y %T\"";
      nowdate = "date +\"%d-%m-%Y\"";
      
      # Network
      ports = "netstat -tulanp";
      ping = "ping -c 5";
      fastping = "ping -c 100 -s.2";
      
      # System info
      meminfo = "free -m -l -t";
      psmem = "ps auxf | sort -nr -k 4";
      psmem10 = "ps auxf | sort -nr -k 4 | head -10";
      pscpu = "ps auxf | sort -nr -k 3";
      pscpu10 = "ps auxf | sort -nr -k 3 | head -10";
      cpuinfo = "lscpu";
      gpumeminfo = "grep -i --color memory /proc/meminfo";
    };
    
    # Bash completion
    enableCompletion = true;
    
    # Custom bashrc additions
    bashrcExtra = ''
      # Welcome message (from bash_profile)
      if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "Welcome to $PRETTY_NAME"
      fi
      echo "Logged in at: $(date)"
      
      # Custom prompt with git branch info
      parse_git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
      }
      
      # Set a colorful prompt
      if [ "$color_prompt" = yes ]; then
        PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\]$(parse_git_branch)\[\033[00m\]\$ '
      else
        PS1='\u@\h:\w$(parse_git_branch)\$ '
      fi
      
      # Enable color support of ls and also add handy aliases
      if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        alias dir='dir --color=auto'
        alias vdir='vdir --color=auto'
      fi
      
      # Colored GCC warnings and errors
      export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
      
      # Function to extract compressed files
      extract() {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }
      
      # Function to create and enter directory
      mkcd() {
        mkdir -p "$1" && cd "$1"
      }
      
      # Function to show disk usage of current directory
      duh() {
        du -sh * | sort -hr
      }
      
      # Function to find files by name
      ff() {
        find . -type f -name "*$1*"
      }
      
      # Function to find directories by name
      fd() {
        find . -type d -name "*$1*"
      }
      
      # Function to show processes using a specific port
      port() {
        lsof -i :$1
      }
    '';
  };

  # Readline configuration (for bash and other programs)
  programs.readline = {
    enable = true;
    extraConfig = ''
      # Vi mode (uncomment if you prefer vi keybindings)
      # set editing-mode vi
      
      # Emacs mode (default)
      set editing-mode emacs
      
      # Case-insensitive completion
      set completion-ignore-case on
      
      # Show all completions immediately
      set show-all-if-ambiguous on
      
      # Append slash to completed directories
      set mark-directories on
      set mark-symlinked-directories on
      
      # Enable incremental search
      "\C-r": reverse-search-history
      "\C-s": forward-search-history
      
      # Better history navigation
      "\e[A": history-search-backward
      "\e[B": history-search-forward
      "\e[C": forward-char
      "\e[D": backward-char
    '';
  };

  # Nano configuration - commented out as programs.nano may not be available in home-manager 25.05
  # programs.nano = {
  #   enable = true;
  #   nanorc = ''
  #     # Enable syntax highlighting
  #     include "/usr/share/nano/*.nanorc"
  #     
  #     # Enable line numbers
  #     set linenumbers
  #     
  #     # Enable mouse support
  #     set mouse
  #     
  #     # Convert tabs to spaces
  #     set tabstospaces
  #     
  #     # Set tab size to 4
  #     set tabsize 4
  #     
  #     # Enable auto-indentation
  #     set autoindent
  #     
  #     # Enable soft word wrapping
  #     set softwrap
  #     
  #     # Show cursor position
  #     set constantshow
  #     
  #     # Enable spell checking
  #     set speller "aspell -x -c"
  #     
  #     # Backup files
  #     set backup
  #     set backupdir "~/.nano/backups"
  #     
  #     # Better search
  #     set casesensitive
  #     set regexp
  #   '';
  # };

  # Create necessary directories (also commented out for now)
  # home.file.".nano/backups/.keep".text = "";

  # Alternative: Use home.file to create .nanorc directly
  home.file.".nanorc".text = ''
    # Enable syntax highlighting
    include "/usr/share/nano/*.nanorc"
    
    # Enable line numbers
    set linenumbers
    
    # Enable mouse support
    set mouse
    
    # Convert tabs to spaces
    set tabstospaces
    
    # Set tab size to 4
    set tabsize 4
    
    # Enable auto-indentation
    set autoindent
    
    # Enable soft word wrapping
    set softwrap
    
    # Show cursor position
    set constantshow
    
    # Enable spell checking
    set speller "aspell -x -c"
    
    # Backup files
    set backup
    set backupdir "~/.nano/backups"
    
    # Better search
    set casesensitive
    set regexp
  '';

  # Create nano backup directory
  home.file.".nano/backups/.keep".text = "";
}