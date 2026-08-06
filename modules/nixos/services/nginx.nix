{
  flake.modules.nixos.services =
    {
      config,
      lib,
      userEmail,
      ...
    }:
    with lib;
    let
      cfg = config.tnix.services.nginx;
    in
    {
      options.tnix.services.nginx = {
        enable = mkEnableOption "Nginx";

        domain = mkOption {
          type = types.str;
          default = "";
          description = "Base domain for the wildcard ACME certificate (disabled when empty)";
        };
      };

      config = mkIf cfg.enable {
        security = {
          acme = {
            acceptTerms = true;
            defaults.email = userEmail;
            certs = mkIf (cfg.domain != "") {
              "${cfg.domain}" = {
                group = "nginx";
                domain = "*.${cfg.domain}";
                extraDomainNames = [ "${cfg.domain}" ];
                dnsProvider = "cloudflare";
                credentialFiles = {
                  CLOUDFLARE_EMAIL_FILE = config.sops.secrets."cloudflare-credentials/email".path;
                  CLOUDFLARE_DNS_API_TOKEN_FILE = config.sops.secrets."cloudflare-credentials/dns-api-token".path;
                };
              };
            };
          };
        };

        users.users.nginx.extraGroups = [ "acme" ];

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
