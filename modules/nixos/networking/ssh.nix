{
  flake.modules.nixos.networking =
    {
      config,
      lib,
      ...
    }:
    with lib;
    let
      cfg = config.tnix.networking.openssh;
    in
    {
      options.tnix.networking.openssh = {
        enable = mkEnableOption "Enable OpenSSH server";

        ports = mkOption {
          type = types.listOf types.port;
          default = [ 22 ];
          description = ''
            Specifies on which ports the SSH daemon listens.
          '';
        };
      };

      config = mkIf cfg.enable {
        programs.ssh.startAgent = true;

        services.openssh = {
          enable = true;
          startWhenNeeded = true;
          allowSFTP = true;
          ports = cfg.ports;

          settings = {
            PermitRootLogin = "no";
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
            AuthenticationMethods = "publickey";
            PubkeyAuthentication = "yes";
            ChallengeResponseAuthentication = "no";
            UsePAM = false;
            UseDns = false;
            X11Forwarding = false;
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
            ClientAliveCountMax = 5;
            ClientAliveInterval = 60;
          };
        };
      };
    };
}
