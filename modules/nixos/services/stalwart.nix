{
  flake.modules.nixos.services = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.tnix.services.stalwart;
    runtimeConfig = "${cfg.dataDir}/etc/config.json";
  in {
    options.tnix.services.stalwart = {
      enable = lib.mkEnableOption "Stalwart mail and collaboration server (1.x)";

      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = pkgs.stalwart_1_0 or null;
        defaultText = lib.literalExpression "pkgs.stalwart_1_0";
        description = ''
          Stalwart 1.x package. The upstream services.stalwart module only supports 0.15,
          so this module runs 1.x with its own systemd unit.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "stalwart";
        description = "User under which Stalwart runs";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "stalwart";
        description = "Group under which Stalwart runs";
      };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/stalwart";
        description = "Directory where Stalwart stores its data (must be under /var/lib)";
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Environment file for Stalwart, e.g. STALWART_RECOVERY_ADMIN=admin:<password> for the
          initial setup. Remove the recovery admin once a permanent administrator exists.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to open the mail ports in the firewall";
      };

      webmail = {
        enable = lib.mkEnableOption ''
          the branded Bulwark Lite webmail bundle. It is linked at
          ''${dataDir}/apps/webmail.zip; point the Stalwart Application's
          resourceUrl at file://<that path> once, then "update applications" after rebuilds
        '';

        brandName = lib.mkOption {
          type = lib.types.str;
          default = "Mailer";
          description = "Name shown in the webmail UI, login page and PWA manifest";
        };

        brandRevision = lib.mkOption {
          type = lib.types.ints.between 1 999;
          default = 2;
          description = ''
            Branding revision baked into the bundle version. Stalwart only installs a newer
            version, so bump this whenever brandName changes. Reset to 1 when the upstream
            webmail version changes.
          '';
        };

        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.webmail.override {
            appName = cfg.webmail.brandName;
            inherit (cfg.webmail) brandRevision;
          };
          defaultText = lib.literalExpression ''
            pkgs.webmail.override {
              appName = config.tnix.services.stalwart.webmail.brandName;
              brandRevision = config.tnix.services.stalwart.webmail.brandRevision;
            }
          '';
          description = "Webmail bundle to install. Setting this ignores brandName and brandRevision.";
        };
      };

      firewallPorts = lib.mkOption {
        type = lib.types.listOf lib.types.port;
        default = [25 465 993 995 4190 443];
        description = "TCP ports opened when openFirewall is true (Stalwart's default listeners, without the 8080 setup port)";
      };
    };

    config = lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.package != null;
          message = "tnix.services.stalwart: pkgs.stalwart_1_0 is not available in this nixpkgs. Update nixpkgs (nix flake update nixpkgs) or set tnix.services.stalwart.package.";
        }
        {
          assertion = cfg.package == null || lib.versionAtLeast cfg.package.version "1.0";
          message = "tnix.services.stalwart only supports Stalwart 1.x. For 0.x use the upstream services.stalwart module.";
        }
      ];

      systemd.services.stalwart = {
        description = "Stalwart mail and collaboration server";
        after = ["network-online.target" "local-fs.target"];
        wants = ["network-online.target"];
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
          # On first start there is no config.json, so Stalwart runs the setup wizard on port 8080
          # and writes the file itself.
          ExecStart = "${lib.getExe cfg.package} --config=${runtimeConfig}";
          Restart = "on-failure";
          RestartSec = 5;
          KillMode = "process";
          KillSignal = "SIGINT";
          LimitNOFILE = 65536;
          WorkingDirectory = cfg.dataDir;
          StateDirectory = [(baseNameOf cfg.dataDir) "${baseNameOf cfg.dataDir}/etc"];
          StateDirectoryMode = "0700";
          CacheDirectory = "stalwart";

          AmbientCapabilities = ["CAP_NET_BIND_SERVICE"];
          CapabilityBoundingSet = ["CAP_NET_BIND_SERVICE"];

          DeviceAllow = [""];
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          PrivateDevices = true;
          PrivateTmp = true;
          PrivateUsers = false; # incompatible with CAP_NET_BIND_SERVICE
          ProcSubset = "pid";
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          RestrictAddressFamilies = ["AF_INET" "AF_INET6" "AF_UNIX"];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = ["@system-service" "~@privileged"];
          UMask = "0077";
        };
      };

      # A stable path, so the Application's resourceUrl survives package updates.
      systemd.tmpfiles.rules = lib.mkIf cfg.webmail.enable [
        "d ${cfg.dataDir}/apps 0700 ${cfg.user} ${cfg.group} -"
        "L+ ${cfg.dataDir}/apps/webmail.zip - - - - ${cfg.webmail.package}"
      ];

      users.users = lib.mkIf (cfg.user == "stalwart") {
        ${cfg.user} = {
          isSystemUser = true;
          group = cfg.group;
          description = "Stalwart service user";
          home = cfg.dataDir;
        };
      };

      users.groups = lib.mkIf (cfg.group == "stalwart") {
        ${cfg.group} = {};
      };

      environment.systemPackages = lib.mkIf (cfg.package != null) [cfg.package];

      networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall cfg.firewallPorts;
    };
  };
}
