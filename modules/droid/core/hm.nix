{ inputs, config, ... }:
{
  flake.modules.nixOnDroid.core =
    {
      hostName,
      userName,
      userEmail,
      ...
    }:
    {
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

        config = {
          imports = [
            config.flake.modules.homeManager.shell
            config.flake.modules.homeManager.${hostName}
          ];
        };
      };
    };
}
