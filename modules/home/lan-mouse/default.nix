{inputs, ...}: {
  imports = [
    inputs.lan-mouse.homeManagerModules.default
  ];

  programs.lan-mouse = {
    enable = true;
    systemd = true;
    settings = {
      # release_bind = ["KeyA" "KeyS" "KeyD" "KeyF"];

      port = 4242;

      authorized_fingerprints = {
        "30:66:b3:95:dc:6b:55:a4:9f:30:31:9c:3e:4d:70:03:33:c3:f0:6f:df:31:35:58:36:6e:80:2f:32:b2:ce:48" = "pc";
      };
    };
  };
}
