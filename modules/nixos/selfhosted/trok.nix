{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.tux.services.trok;
in {
  options.tux.services.trok = {
    enable = mkEnableOption "Enable trok";

    host = mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "Host addr on which the trok service will listen.";
    };

    port = mkOption {
      type = lib.types.port;
      default = 1337;
      description = "Port number on which the trok service will listen.";
    };

    openFirewall = mkEnableOption "Enable firewall port";

    user = mkOption {
      type = types.str;
      default = "trok";
      description = "User under which the trok service runs.";
    };

    group = mkOption {
      type = types.str;
      default = "trok";
      description = "Group under which the trok service runs.";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [cfg.port];

    systemd.services = {
      trok = {
        description = "trok server";
        after = ["network.target"];
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          Type = "simple";
          User = "trok";
          Group = "trok";
          ExecStart = "${getExe pkgs.trok} server -a ${cfg.host}:${toString cfg.port}";
          Restart = "always";

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
          RestrictNamespaces = "uts ipc pid user cgroup";
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = ["@system-service"];
          UMask = "0077";
        };
      };
    };
    # Ensure the user and group exist
    users.users = mkIf (cfg.user == "trok") {
      ${cfg.user} = {
        isSystemUser = true;
        group = cfg.group;
        description = "trok service user";
        home = "/var/lib/trok";
        createHome = true;
      };
    };

    users.groups = mkIf (cfg.group == "trok") {
      ${cfg.group} = {};
    };
  };
}
