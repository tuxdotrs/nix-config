<h3 align="center">
  tux's nix flake
</h3>
<p align="center">
  <a href="https://wakatime.com/badge/user/012e8da9-99fe-4600-891b-bd9d8dce73d9/project/312e6509-0e4f-47b7-b5de-54985b546702" target="_blank"><img alt="home" src="https://wakatime.com/badge/user/012e8da9-99fe-4600-891b-bd9d8dce73d9/project/312e6509-0e4f-47b7-b5de-54985b546702.svg"></a>
  <a href="https://builtwithnix.org" target="_blank"><img alt="home" src="https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a"></a>
  <a href="https://github.com/zemmsoares/awesome-rices" target="_blank"><img alt="home" src="https://raw.githubusercontent.com/zemmsoares/awesome-rices/main/assets/awesome-rice-badge.svg"></a>
  <img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/tuxdotrs/nix-config">
  <img alt="GitHub commit activity" src="https://img.shields.io/github/commit-activity/m/tuxdotrs/nix-config">
</p>
<p align="center">
	<img src="https://github.com/user-attachments/assets/fc28c35f-b87a-4931-ae7f-c231a11fd1a3" alt="desktop">
</p>

## Table of Contents

- [Hosts](#hosts)
- [Installation](#installation)
- [Components](#components)
- [Showcase](#showcase)
- [Pain](#spent-weeks-on-this-system-configuration-)

## Hosts

|     | Hostname   | Board             | CPU                | RAM  | GPU                       | Purpose                                                                            |
| --- | ---------- | ----------------- | ------------------ | ---- | ------------------------- | ---------------------------------------------------------------------------------- |
| 🖥️  | `sirius`   | MSI X570-A Pro    | Ryzen 7 5700X3D    | 64GB | RTX 3080 TI + RTX 3060 TI | Triple-monitor desktop running Windows Subsystem for Linux.                        |
| 💻  | `canopus`  | Asus Zephyrus G15 | Ryzen 9 5900HS     | 16GB | RTX 3060                  | Optimized for productivity on the go and some gaming.                              |
| ☁️  | `homelab`  | Minisforum MS-A1  | Ryzen 7 8700G      | 32GB | Radeon 780M               | WIP                                                                                |
| ☁️  | `arcturus` | KVM               | 4 Core             | 8GB  |                           | Primary server responsible for exposing my homelab applications to the internet.   |
| ☁️  | `alpha`    | KVM               | 4 Core             | 4GB  |                           | Monitors uptime and health status of all services across the infrastructure.       |
| 🥔  | `vega`     | Raspberry Pi 3B+  | Cortex A53         | 1GB  |                           | Running AdGuard Home for network-wide ad blocking.                                 |
| 📱  | `capella`  | Samsung S25 Ultra | Snapdragon 8 Elite | 12GB | Adreno 830                | Primary mobile for daily usage. (Locked)                                           |
| 📱  | `rigel`    | Motorola Edge 30  | Snapdragon 778G+   | 8GB  | Adreno 642L               | Secondary mobile for some fun. (Rooted)                                            |
| ☁️  | `node`     | KVM               | i9-13900           | 64GB |                           | Running Ethereum and BSC nodes. Currently in the process of migrating from Ubuntu. |

## Installation

Boot into NixOS bootable USB and then enter the following commands

```
# Clone this repositry
git clone https://github.com/tuxdotrs/nix-config.git

# Navigate to the repository directory
cd nix-config

# Install disko for disk partitioning
nix-shell -p disko

# Partition the disk and make sure to replace DISK_PATH (eg. /dev/vda)
disko --mode disko ./hosts/canopus/disko.nix --arg device '"DISK_PATH"'

# Generate the hardware.nix file for your system
nixos-generate-config --no-filesystems --root /mnt

# Replace the hardware.nix with generated one
cp /mnt/etc/nixos/hardware-configuration.nix ./hosts/canopus/hardware.nix

# Install
nixos-install --root /mnt --flake .#canopus

# Reboot to your beautiful DE
reboot
```

## Components

|               | Wayland  | Xorg             |
| ------------- | -------- | ---------------- |
| DM            | ly       | ly               |
| WM/DE         | Hyprland | AwesomeWM        |
| Compositor    | Hyprland | Picom (Jonaburg) |
| Bar           | Astal    | Wibar            |
| Hotkeys       | Hyprland | Awful            |
| Launcher      | Astal    | Rofi             |
| Notifications | Astal    | Naughty          |
| Terminal      | Ghostty  | Wezterm          |
| Editor        | Neovim   | Neovim           |

## Showcase

### Desktop

![2024-08-08_18-33](https://github.com/user-attachments/assets/1cdcc387-0f68-486c-a76c-a36ad2acb78d)

![2024-08-08_18-18](https://github.com/user-attachments/assets/f3fc4da5-6c0d-4cda-934d-b68ca6494e02)

### Neovim

![2024-08-08_18-16](https://github.com/user-attachments/assets/f881c672-8d77-43ec-b637-df5004c7d11f)

### Floating Terminal

![2024-08-08_18-16_1](https://github.com/user-attachments/assets/3339ecf8-3264-4179-a093-337c844592a6)

### Lazygit

![2024-08-08_18-16_2](https://github.com/user-attachments/assets/6df15881-fc2b-41b1-af3b-124fe0599b94)

### Telescope

![2024-08-08_18-16_3](https://github.com/user-attachments/assets/03be05bc-8ede-4d6e-a341-2761d89b7288)

### Firefox

![2024-08-08_18-26](https://github.com/user-attachments/assets/6f12173b-2480-404e-b01a-599115a886c0)

## Spent weeks on this system configuration 😢

<div align="center">
  <img src="https://user-images.githubusercontent.com/97862450/265550523-2f66a8b6-4347-40af-89c6-12db3a61cc7c.jpeg" width="60%">
</div>
