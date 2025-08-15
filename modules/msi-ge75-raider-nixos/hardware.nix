# MSI GE75 Raider hardware-specific configuration
# (Gaming optimizations are in profiles/gaming-hardware.nix)
# (Laptop optimizations are in profiles/laptop-base.nix)
{ config, pkgs, ... }:

{
  # Enable Intel CPU microcode updates (for i7-9750H)
  hardware.cpu.intel.updateMicrocode = true;
}
