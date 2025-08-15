# modules/roles/multimedia.nix
# Multimedia role - video/audio codecs, media players, and content creation tools
{ config, pkgs, ... }:
{
  # Modern audio system with PipeWire (better for multimedia and gaming)
  hardware.pulseaudio.enable = false; # Disable PulseAudio in favor of PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true; # For professional audio
  };

  # Multimedia packages
  environment.systemPackages = with pkgs; [
    # Video players and tools
    vlc
    mpv
    ffmpeg
    
    # Audio tools
    audacity
    pavucontrol
    
    # Image/photo tools
    gimp
    imagemagick
    
    # Screen capture and streaming
    obs-studio
    flameshot
    peek
    
    # Media codecs and libraries
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    
    # Video editing (optional - can be heavy)
    # kdenlive
    # blender
  ];

  # Enable hardware-accelerated video playback
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver # Intel
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
  ];
}