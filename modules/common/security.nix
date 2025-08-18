# Security hardening module
{ config, lib, pkgs, ... }:

{
  # Firewall configuration
  networking.firewall = {
    enable = lib.mkDefault true;
    allowedTCPPorts = lib.mkDefault [ 22 ]; # SSH only by default
    allowPing = lib.mkDefault false;
    logReversePathDrops = true;
    
    # Log refused connections
    logRefusedConnections = true;
    logRefusedPackets = true;
    
    # Extra iptables rules
    extraCommands = ''
      # Drop invalid packets
      iptables -A INPUT -m state --state INVALID -j DROP
      
      # Limit SSH connection attempts
      iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set
      iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 60 --hitcount 4 -j DROP
    '';
  };
  
  # Security settings
  security = {
    # Sudo configuration
    sudo = {
      wheelNeedsPassword = lib.mkDefault true;
      execWheelOnly = true;
      extraConfig = ''
        # Timeout after 5 minutes
        Defaults timestamp_timeout=5
        
        # Require password for dangerous operations
        Defaults !targetpw
        Defaults !rootpw
        Defaults !runaspw
      '';
    };
    
    # Polkit for GUI authentication
    polkit.enable = true;
    
    # AppArmor for additional security (optional - may need profiles)
    apparmor = {
      enable = lib.mkDefault false; # Set to true if you want AppArmor
      killUnconfinedConfinables = lib.mkDefault false;
    };
    
    # Protect kernel
    protectKernelImage = true;
    
    # Audit framework
    auditd.enable = lib.mkDefault true;
    audit = {
      enable = lib.mkDefault true;
      rules = [
        "-a exit,always -F arch=b64 -S execve"
      ];
    };
  };
  
  # Kernel hardening
  boot.kernel.sysctl = {
    # Network hardening
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv4.tcp_syncookies" = 1;
    
    # Kernel hardening
    "kernel.kptr_restrict" = 2;
    "kernel.dmesg_restrict" = 1;
    "kernel.printk" = "3 3 3 3";
    "kernel.unprivileged_bpf_disabled" = 1;
    "kernel.yama.ptrace_scope" = 1;
    "net.core.bpf_jit_harden" = 2;
    
    # Disable magic SysRq key
    "kernel.sysrq" = 0;
    
    # Hide kernel pointers
    "kernel.kptr_restrict" = 2;
  };
  
  # Fail2ban for SSH protection
  services.fail2ban = {
    enable = lib.mkDefault true;
    maxretry = 5;
    bantime = "10m";
    bantime-increment = {
      enable = true;
      multipliers = "1 2 4 8 16 32 64";
      maxtime = "168h"; # 1 week
      overalljails = true;
    };
    
    jails = {
      ssh-iptables = ''
        enabled = true
        filter = sshd
        action = iptables-multiport[name=SSH, port="ssh", protocol=tcp]
        maxretry = 3
        findtime = 600
        bantime = 3600
      '';
    };
  };
  
  # SSH hardening
  services.openssh = {
    settings = {
      PermitRootLogin = lib.mkDefault "no";
      # Allow password auth on home network but with strict rate limiting
      # Key-based auth is preferred but passwords provide fallback access
      PasswordAuthentication = lib.mkDefault true;
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
      
      # Only allow specific users/groups
      AllowUsers = lib.mkDefault null;
      AllowGroups = lib.mkDefault [ "wheel" ];
    };
    
    # Use only strong ciphers
    extraConfig = ''
      Protocol 2
      ClientAliveInterval 300
      ClientAliveCountMax 2
      MaxAuthTries 3
      MaxSessions 2
      TCPKeepAlive no
      Compression no
      UseDNS no
    '';
  };
}