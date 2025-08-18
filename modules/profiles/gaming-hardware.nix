# modules/profiles/gaming-hardware.nix
# Profile for gaming hardware optimizations
{ config, lib, pkgs, ... }:
{
  # Gaming hardware optimizations
  boot.kernel.sysctl = {
    # Reduce input lag for gaming
    "kernel.sched_migration_cost_ns" = 5000000;
    "kernel.sched_min_granularity_ns" = 10000000;
    "kernel.sched_wakeup_granularity_ns" = 15000000;
    
    # Improve gaming performance and responsiveness
    "vm.dirty_background_ratio" = 5;
    "vm.dirty_ratio" = 10;
    "vm.swappiness" = 10; # Minimize swapping during gaming
    "vm.vfs_cache_pressure" = 50; # Keep filesystem cache
    
    # Network optimizations for gaming
    "net.core.netdev_max_backlog" = 5000;
    "net.core.rmem_default" = 262144;
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_default" = 262144;
    "net.core.wmem_max" = 16777216;
    
    # Reduce network latency
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_low_latency" = 1;
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  # Gaming-specific kernel parameters
  boot.kernelParams = [
    # CPU performance optimizations
    "processor.max_cstate=1"  # Prevent deep CPU sleep for consistent performance
    "intel_idle.max_cstate=1" # Similar for Intel idle states
    "idle=poll"               # Keep CPU active for minimal latency
    
    # Memory and scheduling optimizations
    "preempt=voluntary"       # Better for gaming workloads
    "nohz=off"                # Disable tickless mode for consistent timing
    
    # GPU/display optimizations
    "nvidia-drm.modeset=1"    # Enable NVIDIA kernel mode setting
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1" # NVIDIA power management
  ];

  # High-performance CPU governor for gaming
  # Force performance mode to override system-optimization.nix default
  powerManagement.cpuFreqGovernor = lib.mkForce "performance";

  # Advanced power management for gaming laptops
  services.tlp = {
    enable = true;
    settings = {
      # Aggressive performance settings
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "ondemand";
      
      # Maximum performance on AC power
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_performance";
      
      # Boost enabled for gaming
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 1;
      
      # Prevent thermal throttling during gaming
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;
      
      # Disable power-saving features during gaming
      PCIE_ASPM_ON_AC = "performance";
      PCIE_ASPM_ON_BAT = "powersave";
      
      # Keep USB devices active for gaming peripherals
      USB_AUTOSUSPEND = 0;
      USB_BLACKLIST = "045e:* 046d:* 1532:*"; # Microsoft, Logitech, Razer devices
    };
  };

  # Hardware monitoring and gaming tools
  environment.systemPackages = with pkgs; [
    # GPU diagnostics and monitoring
    mesa-demos           # glxinfo/glxgears
    nvtopPackages.full   # NVIDIA GPU monitoring
    amdgpu_top          # AMD GPU monitoring
    radeontop           # Radeon GPU monitoring
    
    # System monitoring for gaming performance
    htop
    iotop
    nethogs             # Network bandwidth per process
    stress-ng           # Hardware stress testing
    
    # Temperature and hardware monitoring
    lm_sensors          # Hardware sensors
    mission-center      # Modern system monitoring with GPU support
    
    # Gaming-specific tools
    gamemode            # Automatic gaming optimizations
    mangohud            # Gaming overlay
    goverlay            # MangoHud configurator
  ];

  # Enable GameMode for automatic gaming optimizations
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;          # Higher priority for games
        ioprio = 0;           # Highest I/O priority
        inhibit_screensaver = 1;
        desiredgov = "performance";
      };
      
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };
    };
  };

  # Enhanced Bluetooth for gaming peripherals
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
        FastConnectable = true;
        ReconnectAttempts = 7;
        ReconnectIntervals = "1, 2, 4, 8, 16, 32, 64";
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  # Modern touchpad settings for gaming laptops
  services.libinput.touchpad = {
    naturalScrolling = lib.mkDefault true;
    accelProfile = "adaptive";
    accelSpeed = "0.3";
    disableWhileTyping = true;
  };

  # Audio latency optimizations for gaming
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    
    # Low-latency audio configuration
    extraConfig.pipewire."92-low-latency" = {
      context.properties = {
        default.clock.rate = 48000;
        default.clock.quantum = 32;
        default.clock.min-quantum = 32;
        default.clock.max-quantum = 32;
      };
    };
  };

  # ZRAM optimizations for gaming (fast swap for emergencies)
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25; # Conservative for gaming - prefer real RAM
    priority = 10;      # Lower priority than disk swap
  };
}