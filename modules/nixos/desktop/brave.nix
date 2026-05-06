{
  flake.modules.nixos.desktop = {
    environment.etc."/brave/policies/managed/brave-policies.json".text = builtins.toJSON {
      TorDisabled = true;
      BraveAIChatEnabled = false;
      BraveRewardsDisabled = true;
      BraveWalletDisabled = true;
      BraveVPNDisabled = true;
      BraveNewsDisabled = true;
      BraveTalkDisabled = true;
    };
  };
}
