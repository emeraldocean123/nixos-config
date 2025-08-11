# HP dv9500 Pavilion Dual Boot Setup Guide

## 🎯 Overview

Successfully configured dual boot system with:
- **NixOS Build 28** (Primary, stable)  
- **CachyOS** (Secondary, manual boot)
- **Shared SSH access** on same IP address

## 💾 Hardware Configuration

| Device | Size | Usage | Filesystem |
|--------|------|--------|------------|
| `/dev/sda` | 223.6GB | NixOS | ext4 |
| `/dev/sda1` | 215.7GB | NixOS root/nix | ext4 |  
| `/dev/sda2` | 7.9GB | NixOS swap | swap |
| `/dev/sdb` | 223.6GB | CachyOS | ext4 |
| `/dev/sdb1` | 2GB | CachyOS boot | ext4 |
| `/dev/sdb2` | 8MB | Limine bootloader | - |
| `/dev/sdb3` | 221.6GB | CachyOS root | ext4 |

## 🔄 Boot Process

### Boot into NixOS (Default)
1. Power on → GRUB menu appears
2. Select **"NixOS Build 28"**  
3. ✅ NixOS loads normally

### Boot into CachyOS (Manual)
1. Power on → GRUB menu appears
2. Press **`c`** to enter GRUB command line
3. Type these commands:
   ```
   set root=(hd1)
   chainloader +1  
   boot
   ```
4. ✅ Limine menu → Select CachyOS

## 📡 SSH Access

Both systems use the same IP address but different SSH host keys:

```bash
# IP Addresses
192.168.1.104  # WiFi (preferred)
192.168.1.103  # LAN (backup)

# Username  
joseph

# Connection (host keys differ between systems)
ssh joseph@192.168.1.104
```

## 🛠️ Convenience Scripts

### PowerShell Scripts (Windows)

```powershell
# Connect to current system
.\scripts\connect-nixos.ps1       # Connect to NixOS
.\scripts\connect-cachyos.ps1     # Connect to CachyOS  
.\scripts\check-dual-boot-status.ps1  # Check which system is running

# Interactive sessions
.\scripts\connect-nixos.ps1 -Interactive
.\scripts\connect-cachyos.ps1 -Interactive

# Execute commands remotely
.\scripts\connect-nixos.ps1 -Command "nixos-rebuild list-generations"
.\scripts\connect-cachyos.ps1 -Command "pacman -Syu"
```

### VS Code Tasks

Access via `Ctrl+Shift+P` → "Tasks: Run Task":

- **Dual Boot: Connect to NixOS** - Interactive NixOS session
- **Dual Boot: Connect to CachyOS** - Interactive CachyOS session  
- **Dual Boot: Check System Status** - Full system status
- **Dual Boot: NixOS Info** - Quick NixOS info
- **Dual Boot: CachyOS Info** - Quick CachyOS info

## ⚠️ Important Notes

### NixOS Limitations
- **Only Build 28 works** - Newer builds (29-32) have filesystem detection issues
- **Don't rebuild newer generations** - Stick with Build 28 until GRUB issue is resolved
- **Emergency backup available** at `/tmp/emergency-backup/` on the system

### CachyOS Setup  
- **Browsers installed**: Brave, LibreWolf, Firefox
- **Desktop environment**: Available via GUI login
- **Package manager**: `pacman` (Arch-based)

## 🔧 Troubleshooting

### "Host key verification failed"
Normal when switching between systems. Clear with:
```bash
ssh-keygen -R 192.168.1.104
```

### CachyOS won't boot
1. Verify GRUB commands typed correctly:
   - `set root=(hd1)` 
   - `chainloader +1`
   - `boot`
2. Try booting from different IP (.103 instead of .104)

### NixOS filesystem errors  
- Boot from Build 28 only
- Avoid newer builds until GRUB configuration is fixed
- Emergency backup available if needed

## 📋 System Status

| Component | Status | Notes |
|-----------|--------|-------|
| NixOS Boot | ✅ Working | Build 28 only |
| CachyOS Boot | ✅ Working | Manual GRUB commands |
| SSH Access | ✅ Working | Both systems |
| Dual Boot | ✅ Functional | Manual process |
| Data Safety | ✅ Backed up | Emergency backup created |

## 🎯 Future Improvements

- [ ] Fix NixOS GRUB configuration for newer builds
- [ ] Automate CachyOS boot process
- [ ] Sync SSH host keys between systems
- [ ] Create GRUB menu entry for CachyOS

---

✅ **Dual boot system is fully functional and stable!**