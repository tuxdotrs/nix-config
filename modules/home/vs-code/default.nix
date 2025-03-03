{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default = {
      keybindings = [
        {
          "key" = "f7";
          "command" = "-editor.action.wordHighlight.next";
          "when" = "editorTextFocus && hasWordHighlights";
        }
        {
          "key" = "f7";
          "command" = "-editor.action.accessibleDiffViewer.next";
          "when" = "isInDiffEditor";
        }
        {
          "key" = "f7";
          "command" = "workbench.action.terminal.toggleTerminal";
          "when" = "terminal.active";
        }
        {
          "key" = "ctrl+`";
          "command" = "-workbench.action.terminal.toggleTerminal";
          "when" = "terminal.active";
        }
      ];

      userSettings = {
        "window.zoomLevel" = 2;
        "window.menuBarVisibility" = "toggle";

        "workbench.colorTheme" = "Poimandres Alternate";
        "workbench.startupEditor" = "none";

        "editor.fontFamily" = "FiraCode NF, FiraCode Nerd Font";
        "editor.fontLigatures" = true;
        "editor.cursorBlinking" = "smooth";
        "editor.minimap.enabled" = false;

        "terminal.integrated.fontFamily" = "FiraCode NF, FiraCode Nerd Font , FiraCode";
      };

      extensions =
        (with pkgs.vscode-extensions; [
          wakatime.vscode-wakatime
          ms-dotnettools.csharp
          naumovs.color-highlight
          ms-vscode-remote.remote-containers
          ms-azuretools.vscode-docker
          mikestead.dotenv
          golang.go
          wix.vscode-import-cost
          sumneko.lua
          yzhang.markdown-all-in-one
          jnoortheen.nix-ide
          esbenp.prettier-vscode
          prisma.prisma
          ms-python.python
          ms-vscode-remote.remote-ssh
          humao.rest-client
          bradlc.vscode-tailwindcss
          gruntfuggly.todo-tree
        ])
        ++ (with pkgs.vscode-marketplace; [
          danielpriestley.poimandres-alternate
          pufferbommy.pretty-poimandres
          yoavbls.pretty-ts-errors
          formulahendry.auto-rename-tag
          chakrounanas.turbo-console-log
          streetsidesoftware.code-spell-checker
        ]);
    };
  };
}
