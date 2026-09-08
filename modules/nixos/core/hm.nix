{ inputs, config, ... }:
{
  flake.modules.nixos.core =
    {
      hostName,
      userName,
      userEmail,
      ...
    }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];

      home-manager = {
        backupFileExtension = "bak";
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit
            inputs
            hostName
            userName
            userEmail
            ;
        };

        users.${userName} = {
          imports = [
            config.flake.modules.homeManager.core
            config.flake.modules.homeManager.shell
            config.flake.modules.homeManager.${hostName}
          ];
        };
      };
    };
}
