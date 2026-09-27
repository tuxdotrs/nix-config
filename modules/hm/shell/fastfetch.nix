{
  flake.modules.homeManager.shell = {
    home.file.".config/fastfetch/config.jsonc".text = ''
      {
        "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
        "logo": {
          "type": "data",
          "position": "top",
          "source": "$1   _  ___      ____  ____\n  / |/ (_)_ __/ __ \\/ __/\n /    / /\\ \\ / /_/ /\\ \\  \n/_/|_/_//_\\_\\\\____/___/  ",
          "color": {
            "1": "bold_cyan",
          },
          "padding": {
            "left": 0,
            "top": 0,
          },
        },
        "display": {
          "separator": " ",
          "brightColor": false,
          "color": {
            "keys": "default",
          },
          "size": {
            "maxPrefix": "MB",
            "ndigits": 0,
          },
        },
        "modules": [
          "break",
      {
        "type": "custom",
        "format": "{#1}  ╭───────────╮",
      },
      {
        "type": "title",
        "key": "  │ {#33} {#} user   │",
        "outputColor": "31",
        "format": "{user-name}",
      },
      {
        "type": "title",
        "key": "  │ {#33} {#} hname  │",
        "outputColor": "33",
        "format": "{host-name}",
      },
      {
        "type": "os",
        "key": "  │ {#32}󰻀 {#} distro │",
        "outputColor": "32",
        "format": "{pretty-name}",
      },
      {
        "type": "kernel",
        "key": "  │ {#36}󰌢 {#} kernel │",
        "outputColor": "36",
        "format": "{release}",
      },
      {
        "type": "uptime",
        "key": "  │ {#34} {#} uptime │",
        "outputColor": "34",
        "format": "{?days}{days}d {?}{hours}h {minutes}m",
      },
      {
        "type": "shell",
        "key": "  │ {#35} {#} shell  │",
        "outputColor": "35",
        "format": "{process-name}",
      },
      {
        "type": "memory",
        "key": "  │ {#33}󰍛 {#} memory │",
        "outputColor": "33",
        "format": "{used~0,-4} | {total}",
      },
      {
        "type": "custom",
        "format": "  ├───────────┤",
      },
      {
        "type": "custom",
        "key": "  │ {#37}󰏘 {#} colors │",
        "format": "{#37} {#31} {#33} {#32} {#36} {#34} {#35} {#30}",
      },
      {
        "type": "custom",
        "format": "  ╰───────────╯",
      },
          "break",
        ],
      }
    '';

    programs.fastfetch.enable = true;
  };
}
