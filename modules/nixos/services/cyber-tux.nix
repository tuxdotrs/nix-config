{
  flake.modules.nixos.services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    with lib;
    let
      cfg = config.tnix.services.cyber-tux;
    in
    {
      options.tnix.services.cyber-tux = {
        enable = mkEnableOption "CyberTux Discord bot";

        user = mkOption {
          type = types.str;
          default = "cyber-tux";
          description = "User under which the CyberTux service runs.";
        };

        group = mkOption {
          type = types.str;
          default = "cyber-tux";
          description = "Group under which the CyberTux service runs.";
        };

        dataDir = mkOption {
          type = types.path;
          default = "/var/lib/cyber-tux";
          description = "Directory where CyberTux stores its data.";
        };

        environmentFile = mkOption {
          type = types.path;
          description = "Environment file containing the Discord bot token.";
        };
      };

      config = mkIf cfg.enable {
        systemd.services.cyber-tux = {
          description = "CyberTux Discord bot";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            Type = "simple";
            User = cfg.user;
            Group = cfg.group;
            EnvironmentFile = cfg.environmentFile;
            ExecStart = getExe pkgs.cyber-tux;
            Restart = "always";
            RestartSec = 5;
            WorkingDirectory = cfg.dataDir;
            StateDirectory = baseNameOf cfg.dataDir;
            StateDirectoryMode = "0700";

            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            NoNewPrivileges = true;
            PrivateDevices = true;
            PrivateIPC = true;
            PrivateTmp = true;
            PrivateUsers = true;
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHome = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectProc = "invisible";
            ProtectSystem = "strict";
            RestrictNamespaces = [
              "uts"
              "ipc"
              "pid"
              "user"
              "cgroup"
            ];
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            SystemCallArchitectures = "native";
            SystemCallFilter = [ "@system-service" ];
            UMask = "0077";
          };
        };

        users.users = mkIf (cfg.user == "cyber-tux") {
          ${cfg.user} = {
            isSystemUser = true;
            group = cfg.group;
            description = "CyberTux service user";
            home = cfg.dataDir;
            createHome = true;
          };
        };

        users.groups = mkIf (cfg.group == "cyber-tux") {
          ${cfg.group} = { };
        };
      };
    };
}
