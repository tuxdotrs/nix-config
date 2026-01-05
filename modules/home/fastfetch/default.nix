{...}: {
  home.file.".config/fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "logo": {
        "type": "none",
      },
      "display": {
        "separator": " ",
        "key": {
          "width": 18,
        },
      },
      "modules": [
        {
          "key": "  ╭───────────╮",
          "type": "custom",
        },
        {
          "key": "  │           │\u001b[11D{#31}  user",
          "type": "title",
          "format": "{1}",
        },
        {
          "key": "  │           │\u001b[11D{#34}  hname",
          "type": "command",
          "text": "hostname",
        },
        {
          "key": "  │           │\u001b[11D{#34}󰻀  distro",
          "type": "os",
        },
        {
          "key": "  │           │\u001b[11D{#35}󰌢  kernel",
          "type": "kernel",
        },
        {
          "key": "  │           │\u001b[11D{#31}  uptime",
          "type": "uptime",
        },
        {
          "key": "  │           │\u001b[11D{#32}  shell",
          "type": "shell",
        },
        {
          "key": "  │           │\u001b[11D{#35}  memory",
          "type": "memory",
        },
        {
          "key": "  ├───────────┤",
          "type": "custom",
        },
        {
          "key": "  │           │\u001b[11D{#39}  colors",
          "type": "colors",
          "symbol": "circle",
        },
        {
          "key": "  ╰───────────╯",
          "type": "custom",
        },
      ],
    }
  '';

  programs.fastfetch = {
    enable = true;
  };
}
