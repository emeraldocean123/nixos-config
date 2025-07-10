NixOS Configuration Management - System Configurations
This repository contains pure NixOS system configurations for multiple machines, managed through Nix flakes and home-manager.
Repository Structure

hosts/: Machine-specific system configurations
home/: User-specific home-manager configurations  
modules/: Reusable configuration modules
flake.nix: Nix flake definition and dependencies

Target Systems

HP Pavilion dv9500: Primary development machine (older hardware)
MSI GE75 Raider: Performance machine (newer hardware)

Configuration Guidelines
File Organization:

Keep configurations modular and reusable
Use descriptive names for modules and options
Group related functionality logically
Maintain clear separation between system and user configs

Code Quality:

Include comments explaining configuration choices
Use consistent formatting and indentation
Follow Nix language best practices
Test configurations before deployment

Safety Requirements:

Never commit untested configurations
Backup working configurations before major changes
Use version control effectively
Test changes in safe environments

Deployment Model

Remote SSH-based configuration management
Git-based version control for all configurations
Home-manager for user environment management