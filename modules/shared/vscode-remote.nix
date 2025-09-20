# modules/shared/vscode-remote.nix
# Shared settings for VS Code Remote SSH support on NixOS hosts
{ config, pkgs, lib, ... }:
let
  remoteLibs = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    openssl
    curl
    icu
    freetype
    fontconfig
    glib
    gtk3
    alsa-lib
    nss
    nspr
    at-spi2-atk
    libdrm
    expat
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
    xorg.libxkbfile
    xorg.libxshmfence
    mesa
    pango
    systemd
  ];
in {
  programs.nix-ld = {
    enable = true;
    libraries = remoteLibs;
  };

  environment.systemPackages = with pkgs; [
    nodejs
  ];

  services.openssh = {
    enable = lib.mkDefault true;
    settings = {
      PermitRootLogin = lib.mkDefault "no";
      PasswordAuthentication = lib.mkDefault true;
      X11Forwarding = lib.mkDefault true;
    };
    extraConfig = lib.mkBefore ''
      # VS Code Remote SSH specific settings
      StreamLocalBindUnlink yes
      AcceptEnv LANG LC_*
    '';
  };
}
