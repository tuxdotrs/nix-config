{ inputs, ... }: {
  flake.modules.nixos.services =
    {
      config,
      lib,
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
        };

        users.users.${userName}.extraGroups = [ "hermes" ];
      };
    };
}
