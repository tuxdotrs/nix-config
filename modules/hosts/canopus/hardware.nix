{ inputs, config, ... }:
{
  flake.modules.nixos.canopus =
    {
      lib,
      pkgs,
      system,
      ...
    }@innerArgs:
    {
      imports =
        with config.flake.modules.nixos;
        [
          hardware
        ]
        ++ [ inputs.nixos-hardware.nixosModules.asus-zephyrus-ga503 ];

      boot.kernelParams = [ "nvidia-drm.modeset=1" ];
      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      hardware = {
        nvidia = {
          modesetting.enable = true;
          open = false;
          nvidiaSettings = true;
        };

        cpu.amd.updateMicrocode = lib.mkDefault innerArgs.config.hardware.enableRedistributableFirmware;
      };

      services = {
        xserver.videoDrivers = [ "nvidia" ];
        power-profiles-daemon.enable = true;
        upower.enable = true;

        supergfxd = {
          enable = true;
          settings = {
            mode = "Hybrid";
            vfio_enable = false;
            vfio_save = false;
            always_reboot = false;
            no_logind = false;
            logout_timeout_s = 180;
            hotplug_type = "None";
          };
        };

        asusd = {
          enable = true;
          asusdConfig.text = ''
            (
              charge_control_end_threshold: 80,
              disable_nvidia_powerd_on_battery: true,
              ac_command: "",
              bat_command: "",

              platform_profile_linked_epp: true,
              platform_profile_on_battery: Quiet,
              platform_profile_on_ac: Performance,

              change_platform_profile_on_battery: true,
              change_platform_profile_on_ac: true,

              profile_quiet_epp: Power,
              profile_balanced_epp: BalancePower,
              profile_custom_epp: Performance,
              profile_performance_epp: Performance,

              ac_profile_tunings: {},
              dc_profile_tunings: {},
              armoury_settings: {},
            )
          '';
          profileConfig.text = ''
            (
              active_profile: Quiet,
            )
          '';
          fanCurvesConfig.text = ''
            (
              profiles: (
                balanced: [
                  (
                    fan: CPU,
                    pwm: (20, 40, 60, 85, 110, 140, 170, 200),
                    temp: (45, 55, 62, 68, 74, 80, 86, 92),
                    enabled: true,
                  ),
                  (
                    fan: GPU,
                    pwm: (20, 40, 60, 85, 110, 140, 170, 200),
                    temp: (45, 55, 62, 68, 74, 80, 86, 92),
                    enabled: true,
                  ),
                ],
                performance: [
                  (
                    fan: CPU,
                    pwm: (35, 60, 90, 120, 150, 180, 220, 255),
                    temp: (45, 55, 62, 68, 74, 80, 86, 92),
                    enabled: true,
                  ),
                  (
                    fan: GPU,
                    pwm: (35, 60, 90, 120, 150, 180, 220, 255),
                    temp: (45, 55, 62, 68, 74, 80, 86, 92),
                    enabled: true,
                  ),
                ],
                quiet: [
                  (
                    fan: CPU,
                    pwm: (0, 10, 20, 35, 55, 80, 110, 140),
                    temp: (45, 55, 62, 68, 74, 80, 86, 92),
                    enabled: true,
                  ),
                  (
                    fan: GPU,
                    pwm: (0, 10, 20, 35, 55, 80, 110, 140),
                    temp: (45, 55, 62, 68, 74, 80, 86, 92),
                    enabled: true,
                  ),
                ],
                custom: [],
              ),
            )
          '';
        };
      };

      networking.useDHCP = lib.mkDefault true;
      nixpkgs.config.cudaSupport = true;
      nixpkgs.hostPlatform = lib.mkDefault system;

      environment.systemPackages = with pkgs; [
        nvtopPackages.full
      ];
    };
}
