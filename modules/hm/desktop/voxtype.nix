{ inputs, ... }: {
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    imports = [
      inputs.voxtype.homeManagerModules.default
    ];

    programs.voxtype = {
      enable = true;
      package = pkgs.voxtype.onnx-cuda;
      engine = "parakeet";
      model.path = "/home/tux/.local/share/voxtype/models/parakeet-tdt-0.6b-v3";
      service.enable = true;
      settings = {
        hotkey.enabled = false;
        whisper.language = "en";
      };
    };
  };
}
