{ lib, ... }:
{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      programs.zsh = {
        enable = true;
        history = {
          append = true;
          share = true;
          expireDuplicatesFirst = true;
          ignoreDups = true;
          size = 1000000;
          save = 1000000;
          path = "$HOME/.local/share/zsh/.zsh_history";
        };
        fastSyntaxHighlighting.enable = true;
        autosuggestion.enable = true;
        initContent = ''
          ${lib.getExe pkgs.fastfetch}
          bindkey "^A" vi-beginning-of-line
          bindkey "^E" vi-end-of-line
          bindkey '^R' fzf-history-widget

          PATH=$PATH:~/.cargo/bin:~/.local/bin
          alias stui='systemctl-tui'
        '';
      };
    };
}
