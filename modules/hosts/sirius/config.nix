{ config, ... }:
{
  flake.modules.nixos.sirius =
    {
      lib,
      pkgs,
      hostName,
      userName,
      userEmail,
      ...
    }:
    {

      imports = with config.flake.modules.nixos; [ desktop ];

      # --- Boot ---
      boot = {
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
        kernelPackages = pkgs.linuxKernel.packages.linux_zen;
        kernelParams = [ "nvidia-drm.modeset=1" ];
      };

      # --- Networking ---
      networking = {
        hostName = hostName;
        networkmanager = {
          enable = true;
          wifi.backend = "iwd";
        };
        wireless.iwd = {
          enable = true;
          settings = {
            Network = {
              EnableIPv6 = true;
            };
            Settings = {
              AutoConnect = true;
            };
          };
        };
        firewall.enable = false;
      };

      # --- Hardware / GPU ---
      hardware = {
        graphics = {
          enable = true;
          enable32Bit = true;
        };
        nvidia = {
          modesetting.enable = true;
          open = false;
          nvidiaSettings = true;
        };

        enableAllFirmware = true;
        usb-modeswitch.enable = true;
      };

      services.xserver.videoDrivers = [ "nvidia" ];

      # --- SSH ---
      services.openssh = {
        enable = true;
        startWhenNeeded = true;
        allowSFTP = true;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          AuthenticationMethods = "publickey";
          PubkeyAuthentication = "yes";
          UsePAM = false;
          UseDns = false;
          X11Forwarding = false;
          ClientAliveCountMax = 5;
          ClientAliveInterval = 60;

          KexAlgorithms = [
            "curve25519-sha256"
            "curve25519-sha256@libssh.org"
            "diffie-hellman-group16-sha512"
            "diffie-hellman-group18-sha512"
            "sntrup761x25519-sha512@openssh.com"
            "diffie-hellman-group-exchange-sha256"
            "mlkem768x25519-sha256"
            "sntrup761x25519-sha512"
          ];
          Macs = [
            "hmac-sha2-512-etm@openssh.com"
            "hmac-sha2-256-etm@openssh.com"
            "umac-128-etm@openssh.com"
          ];
        };
      };

      # --- Programs ---
      programs.firefox.enable = true;

      # --- Packages ---
      environment.systemPackages = with pkgs; [
        discord
        brave
        zed-editor
      ];

      # !!! DO NOT CHANGE THIS !!!
      # This should match the version used at initial install.
      system.stateVersion = "26.05";
    };
}
