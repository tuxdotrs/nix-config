{config, ...}: let
  isFirewallEnabled = config.networking.firewall.enable;
in {
  services.fail2ban = {
    enable = isFirewallEnabled;
    maxretry = 5;
    banaction = "iptables-multiport[blocktype=DROP]";
    ignoreIP = [
      "127.0.0.0/8"
      "10.0.0.0/8"
      "192.168.0.0/16"
    ];
    bantime = "24h";

    bantime-increment = {
      enable = true;
      rndtime = "12m";
      overalljails = true;
      multipliers = "4 8 16 32 64 128 256 512 1024 2048";
      maxtime = "192h";
    };

    jails = {
      sshd.settings = {
        enabled = true;
        port = toString config.services.openssh.ports;
        mode = "aggressive";
        filter = "sshd";
      };
    };
  };
}
