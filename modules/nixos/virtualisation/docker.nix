{
  flake.modules.nixos.virtualisation =
    {
      config,
      lib,
      pkgs,
      userName,
      ...
    }:
    let
      cfg = config.tnix.virtualisation;
    in
    {
      options.tnix.virtualisation.docker = {
        enable = lib.mkEnableOption "Docker container runtime";
        nvidia = {
          enable = lib.mkEnableOption "NVIDIA Container Toolkit for Docker";
        };
      };

      config = lib.mkIf cfg.docker.enable {
        virtualisation = {
          oci-containers.backend = "docker";
          docker.enable = true;
        };

        hardware.nvidia-container-toolkit.enable = lib.mkIf cfg.docker.nvidia.enable true;
        environment.systemPackages = with pkgs; [ lazydocker ];
        users.users.${userName}.extraGroups = [ "docker" ];
      };
    };
}
