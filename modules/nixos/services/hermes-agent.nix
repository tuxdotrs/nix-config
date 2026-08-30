{ inputs, ... }: {
  flake.modules.nixos.services =
    {
      config,
      lib,
      pkgs,
      options,
      userName,
      ...
    }:
    with lib;
    let
      cfg = config.tnix.services.hermes-agent;
    in
    {
      imports = [
        inputs.hermes-agent.nixosModules.default
      ];

      options.tnix.services.hermes-agent = {
        enable = mkEnableOption "Hermes Agent";
        environmentFiles = options.services.hermes-agent.environmentFiles;
      };

      config = mkIf cfg.enable {
        services.hermes-agent = {
          enable = true;
          settings.model = {
            provider = "opencode-go";
            default = "deepseek-v4-flash";
          };
          environmentFiles = cfg.environmentFiles;
          addToSystemPackages = true;

          extraPlugins = [
            (pkgs.fetchFromGitHub {
              owner = "DietrichGebert";
              repo = "ponytail";
              rev = "v4.9.0";
              hash = "sha256-8cYggVltBAlZ/Zj4pl1bOu7mQdZFXCmDGW4RSpvRA+w=";
            })
          ];
        };

        users.users.${userName}.extraGroups = [ "hermes" ];
      };
    };
}
