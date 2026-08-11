{ lib, ... }:
{
  flake.modules.homeManager.vega = {
    # @TODO: Broken currently - By default it's enabled by neovim module
    programs.vim.enable = lib.mkForce false;

    home.stateVersion = "26.05";
  };
}
