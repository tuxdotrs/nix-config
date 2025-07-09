{...}: {
  programs.starship = {
    enable = true;
    settings = {
      format = ''$os$hostname$directory$rust$golang$solidity$nodejs(bold blue)$git_branch$git_status[❯](bold yellow)[❯](bold purple)[❯](bold blue) '';
      scan_timeout = 60;
      add_newline = false;
      line_break.disabled = true;

      os = {
        format = "[$symbol  ]($style)";
        style = "bold green";
        disabled = false;
        symbols.NixOS = "󰊠";
        symbols.Linux = "󰊠";
        symbols.Arch = "󰣇";
        symbols.Ubuntu = "󰕈";
      };
      directory = {
        format = "[$path]($style)[$read_only ]($read_only_style)";
        read_only = " 󰌾";
        style = "bold blue";
      };
      git_branch.format = "[$symbol$branch]($style) ";
      hostname = {
        ssh_only = false;
        format = "[$ssh_symbol$hostname]($style) ";
        style = "bold green";
        ssh_symbol = "󰇧 ";
        disabled = false;
      };
      rust = {
        format = "[$symbol]($style)";
        symbol = " ";
      };
      golang = {
        format = "[$symbol]($style)";
        symbol = " ";
      };
      solidity = {
        format = "[$symbol]($style)";
        symbol = "󰡪 ";
      };
      nodejs = {
        format = "[$symbol]($style)";
        symbol = "󰎙 ";
      };
    };
  };
}
