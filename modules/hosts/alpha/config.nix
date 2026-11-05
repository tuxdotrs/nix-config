{
  inputs,
  config,
  ...
}: {
  flake.modules.nixos.alpha = {
    hostName,
    userName,
    ...
  } @ innerArgs: {
    imports = with config.flake.modules.nixos;
      [
        boot
        networking
        virtualisation
        services
        monitoring
      ]
      ++ [
        inputs.trok.nixosModules.default
        inputs.tfolio.nixosModules.default
      ];

    tnix = {
      boot = {
        legacy.enable = true;

        impermanence = {
          enable = true;

          home = {
            directories = [
              ".local/share/nvim"
              ".local/share/zsh"
              ".local/share/zoxide"
              ".local/state/lazygit"
              ".local/share/opencode"
            ];
          };
        };
      };

      networking = {
        openssh = {
          enable = true;
          ports = [
            23
          ];
        };
        netbird-client.enable = true;
      };

      services = {
        pangolin = {
          enable = true;
          domain = "lab.tux.rs";
          baseDomain = "tux.rs";
          environmentFile = innerArgs.config.sops.secrets."pangolin".path;
        };

        forgejo = {
          enable = true;
          domain = "git.tux.rs";
        };

        uptime-kuma = {
          enable = true;
          domain = "status.tux.rs";
        };

        wakapi = {
          enable = true;
          domain = "wakapi.tux.rs";
          environmentFiles = [innerArgs.config.sops.secrets."wakapi".path];
        };

        mediaflow-proxy = {
          enable = true;
          environmentFile = innerArgs.config.sops.secrets."mediaflow-proxy".path;
        };

        trok = {
          enable = true;
        };
      };

      virtualisation = {
        docker.enable = true;
      };

      monitoring = {
        loki.enable = true;
        prometheus.enable = true;

        grafana = {
          enable = true;
          domain = "grafana.tux.rs";
          adminPasswordFile = innerArgs.config.sops.secrets.grafana-admin-password.path;
          secretKeyFile = innerArgs.config.sops.secrets.grafana-secret-key.path;
        };

        alloy = {
          enable = true;
          environmentFile = innerArgs.config.sops.secrets.alloy.path;
        };
      };
    };

    sops.secrets = {
      tux-password = {
        sopsFile = ./secrets.yaml;
        neededForUsers = true;
      };

      gemini-api-key = {
        sopsFile = ./secrets.yaml;
        owner = userName;
      };

      openrouter-api-key = {
        sopsFile = ./secrets.yaml;
        owner = userName;
      };

      opencode-go-api-key = {
        sopsFile = ./secrets.yaml;
        owner = userName;
      };

      zai-coding-plan-api-key = {
        sopsFile = ./secrets.yaml;
        owner = userName;
      };

      netbird-key = {
        sopsFile = ./secrets.yaml;
        owner = userName;
      };

      "cloudflare-credentials/email" = {
        sopsFile = ./secrets.yaml;
      };

      "cloudflare-credentials/dns-api-token" = {
        sopsFile = ./secrets.yaml;
      };

      aiostreams = {
        sopsFile = ./secrets.yaml;
      };

      mediaflow-proxy = {
        sopsFile = ./secrets.yaml;
      };

      pangolin = {
        sopsFile = ./secrets.yaml;
      };

      wakapi = {
        sopsFile = ./secrets.yaml;
      };

      grafana-admin-password = {
        sopsFile = ./secrets.yaml;
        owner = "grafana";
      };

      grafana-secret-key = {
        sopsFile = ./secrets.yaml;
        owner = "grafana";
      };

      alloy = {
        sopsFile = ./secrets.yaml;
      };
    };

    # --- Networking ---
    networking = {
      hostName = hostName;
      networkmanager.enable = true;
      firewall.enable = false;
    };

    services.tfolio.enable = true;

    system.stateVersion = "26.05";
  };
}
