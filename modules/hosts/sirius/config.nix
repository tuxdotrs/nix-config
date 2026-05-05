{
  flake.modules.nixos.sirius =
    {
      config,
      lib,
      pkgs,
      hostName,
      userName,
      userEmail,
      ...
    }:
    {
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
          package = config.boot.kernelPackages.nvidiaPackages.stable;
          modesetting.enable = true;
          open = false;
          nvidiaSettings = true;
        };

        enableAllFirmware = true;
        usb-modeswitch.enable = true;
      };

      services.xserver.videoDrivers = [ "nvidia" ];

      # --- Locale ---
      time.timeZone = "Asia/Kolkata";
      i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = lib.genAttrs [
          "LC_ADDRESS"
          "LC_IDENTIFICATION"
          "LC_MEASUREMENT"
          "LC_MONETARY"
          "LC_NAME"
          "LC_NUMERIC"
          "LC_PAPER"
          "LC_TELEPHONE"
          "LC_TIME"
        ] (_: "en_IN");
      };

      # --- Desktop ---
      services = {
        displayManager.ly.enable = true;
        desktopManager.plasma6.enable = true;
      };

      # --- Fonts ---
      fonts.packages = with pkgs.nerd-fonts; [
        fira-code
        jetbrains-mono
        bigblue-terminal
      ];

      # --- Audio ---
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
      };

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
        neovim
        discord
        pciutils
        brave
        zed-editor
        usbutils
      ];

      # !!! DO NOT CHANGE THIS !!!
      # This should match the version used at initial install.
      system.stateVersion = "26.05";
    };
}
