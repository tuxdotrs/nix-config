{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      home.file = {
        ".config/nvim" = {
          recursive = true;
          source = "${pkgs.tnvim}";
        };
      };

      programs = {
        neovim = {
          enable = true;
          defaultEditor = true;
          vimAlias = true;
        };
      };

      home = {
        packages = with pkgs; [
          python3
          nodejs
          go
          rustup
          typescript
          neovide
          nil
          statix
          deadnix
          alejandra
          luarocks
          gdu
          gcc
          wakatime-cli
        ];
      };
    };
}
