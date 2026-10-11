{inputs, ...}: {
  flake.modules.nixos.services = {
    config,
    lib,
    pkgs,
    options,
    userName,
    ...
  }: let
    cfg = config.tnix.services.hermes-agent;
  in {
    imports = [
      inputs.hermes-agent.nixosModules.default
    ];

    options.tnix.services.hermes-agent = {
      enable = lib.mkEnableOption "Hermes Agent";
      environmentFiles = options.services.hermes-agent.environmentFiles;
    };

    config = lib.mkIf cfg.enable {
      services.hermes-agent = {
        enable = true;
        settings.model = {
          provider = "zai";
          default = "glm-5.3-flash";
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

      environment.systemPackages = with pkgs; [
        nodejs
        agent-browser
        ffmpeg
      ];

      users.users.${userName}.extraGroups = ["hermes"];
    };
  };
}
