{
  flake.modules.nixos.services = {
    config,
    lib,
    userEmail,
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
              credentialFiles = {
                CLOUDFLARE_EMAIL_FILE = config.sops.secrets."cloudflare-credentials/email".path;
                CLOUDFLARE_DNS_API_TOKEN_FILE = config.sops.secrets."cloudflare-credentials/dns-api-token".path;
              };
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
