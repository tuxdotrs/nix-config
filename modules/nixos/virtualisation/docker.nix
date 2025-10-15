{
  username,
  pkgs,
  ...
}: {
  virtualisation = {
    oci-containers.backend = "docker";
    docker.enable = true;
  };

  hardware.nvidia-container-toolkit.enable = true;

  environment.systemPackages = with pkgs; [lazydocker];

  users.users.${username}.extraGroups = ["docker"];
}
