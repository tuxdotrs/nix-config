{
  flake.modules.nixos.services = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.tnix.services.orca-server;
  in {
    options.tnix.services.orca-server = {
      enable = lib.mkEnableOption "Orca IDE headless runtime server";

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.llm-agents.orca;
        defaultText = lib.literalExpression "pkgs.llm-agents.orca";
        description = ''
          Orca IDE package to run.
          The package is expected to provide the `orca-ide` launcher.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "orca";
        description = ''
          User account under which Orca runs.
          The default account is created by this module; any other user
          is expected to already exist, along with its home directory.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "orca";
        description = "Group under which Orca runs.";
      };

      home = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/orca";
        description = ''
          Persistent home directory used by the Orca service.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 6768;
        description = ''
          WebSocket port for the Orca runtime.

          `orca serve` always binds 0.0.0.0 and has no listen-address
          flag, so limiting who can reach this port is the host's job,
          via the firewall or by routing it over an overlay network only.
        '';
      };

      pairingAddress = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Address advertised to Orca clients.

          This does not change the listen address. It should be reachable
          from the client, for example a Tailscale IP, LAN hostname, or
          reverse-proxy URL.
        '';
        example = "100.64.1.20";
      };

      extraArgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = ''
          Additional arguments passed to `orca-ide serve`.
        '';
        example = ["--json"];
      };
    };

    config = lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.pairingAddress != "";
          message = "tnix.services.orca-server.pairingAddress must be set when tnix.services.orca-server.enable is true.";
        }
      ];

      systemd.services.orca-server = {
        description = "Orca IDE runtime server";

        after = [
          "network-online.target"
        ];

        wants = [
          "network-online.target"
        ];

        wantedBy = [
          "multi-user.target"
        ];

        # Orca starts its own Xvfb when DISPLAY is unset.
        path = [
          pkgs.xorg-server
        ];

        startLimitIntervalSec = 300;
        startLimitBurst = 5;

        serviceConfig = {
          Type = "simple";

          User = cfg.user;
          Group = cfg.group;

          WorkingDirectory = cfg.home;

          Environment = [
            "HOME=${cfg.home}"
            "LIBGL_ALWAYS_SOFTWARE=1"
          ];

          ExecStart = lib.escapeShellArgs (
            [
              "${cfg.package}/bin/orca-ide"
              "serve"
              "--port"
              (toString cfg.port)
              "--pairing-address"
              cfg.pairingAddress
            ]
            ++ cfg.extraArgs
          );

          StandardOutput = "journal";
          StandardError = "journal";

          # Electron spawns a process tree that outlives the main PID.
          KillMode = "mixed";

          Restart = "on-failure";
          RestartSec = 5;

          # Hardening is limited to what the Chromium sandbox and the
          # V8 JIT tolerate: namespace, syscall-filter and W^X
          # restrictions all break the renderer.
          LockPersonality = true;
          NoNewPrivileges = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectSystem = "full";
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
        };
      };

      users.users = lib.mkIf (cfg.user == "orca") {
        ${cfg.user} = {
          isSystemUser = true;
          group = cfg.group;
          description = "Orca service user";
          home = cfg.home;
          createHome = true;
        };
      };

      users.groups = lib.mkIf (cfg.group == "orca") {
        ${cfg.group} = {};
      };
    };
  };
}
