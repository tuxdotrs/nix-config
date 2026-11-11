{
  flake.modules.nixos.services = {
    config,
    lib,
    userEmail,
    options,
    ...
  }: let
    cfg = config.tnix.services.nginx;
  in {
    options.tnix.services.nginx = {
      enable = lib.mkEnableOption "Nginx";

      domain = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Base domain for the wildcard ACME certificate (disabled when empty)";
      };

      credentialFiles = (options.security.acme.defaults.type.getSubOptions []).credentialFiles;
    };

    config = lib.mkIf cfg.enable {
      security = {
        acme = {
          acceptTerms = true;
          defaults.email = userEmail;
          certs = lib.mkIf (cfg.domain != "") {
            "${cfg.domain}" = {
              group = "nginx";
              domain = "*.${cfg.domain}";
              extraDomainNames = ["${cfg.domain}"];
              dnsProvider = "cloudflare";
              credentialFiles = cfg.credentialFiles;
            };
          };
        };
      };

      users.users.nginx.extraGroups = ["acme"];

      services.nginx = {
        enable = true;
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
      };
    };
  };
}
