{
  flake.modules.nixOnDroid.networking =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      # utility functions
      concatLines = list: builtins.concatStringsSep "\n" list;

      prefixLines = mapper: list: concatLines (map mapper list);

      # could be put in the config
      configPath = "ssh/sshd_config";

      keysFolder = "/etc/ssh";

      authorizedKeysFolder = "/etc/ssh/authorized_keys.d";

      supportedKeysTypes = [
        "rsa"
        "ed25519"
      ];

      sshd-start-bin = "sshd-start";

      # real config
      cfg = config.tnix.networking.openssh;

      pathOfKeyOf = type: "${keysFolder}/ssh_host_${type}_key";

      generateKeyOf = type: ''
        ${lib.getExe' pkgs.openssh "ssh-keygen"} \
          -t "${type}" \
          -f "${pathOfKeyOf type}" \
          -N ""
      '';

      generateKeyWhenNeededOf = type: ''
        if [ ! -f ${pathOfKeyOf type} ]; then
          mkdir --parents ${keysFolder}
          ${generateKeyOf type}
        fi
      '';

      sshd-start = pkgs.writeScriptBin sshd-start-bin ''
        #!${pkgs.runtimeShell}
        ${prefixLines generateKeyWhenNeededOf supportedKeysTypes}

        mkdir --parents "${authorizedKeysFolder}"
        echo "${lib.concatStringsSep "\n" cfg.authorizedKeys}" > ${authorizedKeysFolder}/${config.user.userName}

        echo "Starting sshd in non-daemonized way on port ${lib.concatMapStrings toString cfg.ports}"
        ${lib.getExe' pkgs.openssh "sshd"} \
          -f "/etc/${configPath}" \
          -D # don't detach into a daemon process
      '';
    in
    {
      options.tnix.networking.openssh = {
        enable = lib.mkEnableOption ''
          Whether to enable the OpenSSH secure shell daemon, which
          allows secure remote logins.
        '';

        ports = lib.mkOption {
          type = lib.types.listOf lib.types.port;
          default = [ 22 ];
          description = ''
            Specifies on which ports the SSH daemon listens.
          '';
        };

        authorizedKeys = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = ''
            Specify a list of public keys to be added to the authorized_keys file.
          '';
        };
      };

      config = lib.mkIf cfg.enable {
        environment.etc = {
          "${configPath}".text = ''
            ${prefixLines (port: "Port ${toString port}") cfg.ports}

            AuthorizedKeysFile ${authorizedKeysFolder}/%u

            LogLevel VERBOSE
          '';
        };

        environment.packages = [
          sshd-start
          pkgs.openssh
        ];

        build.activationAfter.sshd = ''
          SERVER_PID=$(${lib.getExe' pkgs.procps "ps"} -a | ${lib.getExe' pkgs.toybox "grep"} sshd || true)
          if [ -z "$SERVER_PID" ]; then
            $DRY_RUN_CMD ${lib.getExe sshd-start}
          fi
        '';
      };
    };
}
