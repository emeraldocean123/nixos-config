# HP dv9500 Pavilion hardware-specific configuration
# (Legacy optimizations are in profiles/legacy-hardware.nix)
# (Laptop optimizations are in profiles/laptop-base.nix)
{ config, pkgs, ... }:

{
  # Enable AMD CPU microcode updates (for AMD Turion 64 X2)
  hardware.cpu.amd.updateMicrocode = true;
}
