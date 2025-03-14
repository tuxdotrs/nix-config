{pkgs, ...}: let
  bg = "default";
  fg = "default";
  bg2 = "brightblack";
  fg2 = "white";
  color = c: "#{@${c}}";

  indicator = let
    accent = color "indicator_color";
    content = "  ";
  in "#[reverse,fg=${accent}]#{?client_prefix,${content},}";

  current_window = let
    accent = color "main_accent";
    index = "#[reverse,fg=${accent},bg=${fg}] #I ";
    name = "#[fg=${bg2},bg=${fg2}] #W ";
    # flags = "#{?window_flags,#{window_flags}, }";
  in "${index}${name}";

  window_status = let
    accent = color "window_color";
    index = "#[reverse,fg=${accent},bg=${fg}] #I ";
    name = "#[fg=${bg2},bg=${fg2}] #W ";
    # flags = "#{?window_flags,#{window_flags}, }";
  in "${index}${name}";

  battery = let
    percentage = pkgs.writeShellScript "percentage" (
      if pkgs.stdenv.isDarwin
      then ''
        echo $(pmset -g batt | grep -o "[0-9]\+%" | tr '%' ' ')
      ''
      else ''
        path="/org/freedesktop/UPower/devices/DisplayDevice"
        echo $(${pkgs.upower}/bin/upower -i $path | grep -o "[0-9]\+%" | tr '%' ' ')
      ''
    );
    state = pkgs.writeShellScript "state" (
      if pkgs.stdenv.isDarwin
      then ''
        echo $(pmset -g batt | awk '{print $4}')
      ''
      else ''
        path="/org/freedesktop/UPower/devices/DisplayDevice"
        echo $(${pkgs.upower}/bin/upower -i $path | grep state | awk '{print $2}')
      ''
    );
    icon = pkgs.writeShellScript "icon" ''
      percentage=$(${percentage})
      state=$(${state})
      if [ "$state" == "charging" ] || [ "$state" == "fully-charged" ]; then echo "󰂄"
      elif [ $percentage -ge 75 ]; then echo "󱊣"
      elif [ $percentage -ge 50 ]; then echo "󱊢"
      elif [ $percentage -ge 25 ]; then echo "󱊡"
      elif [ $percentage -ge 0  ]; then echo "󰂎"
      fi
    '';
    color = pkgs.writeShellScript "color" ''
      percentage=$(${percentage})
      state=$(${state})
      if [ "$state" == "charging" ] || [ "$state" == "fully-charged" ]; then echo "green"
      elif [ $percentage -ge 75 ]; then echo "green"
      elif [ $percentage -ge 50 ]; then echo "${fg2}"
      elif [ $percentage -ge 30 ]; then echo "yellow"
      elif [ $percentage -ge 0  ]; then echo "red"
      fi
    '';
  in "#[fg=#(${color})]#(${icon}) #[fg=${fg}]#(${percentage})%";

  pwd = let
    accent = color "main_accent";
    icon = "#[fg=${accent}] ";
    format = "#[fg=${fg}]#{b:pane_current_path}";
  in "${icon}${format}";

  git = let
    icon = pkgs.writeShellScript "branch" ''
      git -C "$1" branch && echo " "
    '';
    branch = pkgs.writeShellScript "branch" ''
      git -C "$1" rev-parse --abbrev-ref HEAD
    '';
  in "#[fg=magenta]#(${icon} #{pane_current_path})#(${branch} #{pane_current_path})";

  separator = "#[fg=${fg}]|";
in {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0;
    mouse = true;
    extraConfig = ''
      set-option -sa terminal-overrides ",xterm*:Tc"
      set-option -g status-position top
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

      # remap prefix from C-b to C-Space
      # unbind C-b
      # set -g prefix C-Space
      # bind C-Space send-prefix

      # split panes using | and -
      unbind '"'
      unbind %
      bind | split-window -h
      bind - split-window -v

      # Start windows and panes at 1, not 0
      set -g base-index 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # switch panes using Alt-arrow without prefix
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      set-option -g default-terminal "screen-256color"
      set-option -g status-right-length 100
      set-option -g @indicator_color "yellow"
      set-option -g @window_color "magenta"
      set-option -g @main_accent "blue"
      set-option -g pane-active-border fg=black
      set-option -g pane-border-style fg=black
      set-option -g status-style "bg=${bg} fg=${fg}"
      set-option -g status-left "${indicator}"
      set-option -g status-right "${git} ${pwd} ${separator} ${battery}"
      set-option -g window-status-current-format "${current_window}"
      set-option -g window-status-format "${window_status}"
      set-option -g window-status-separator ""
    '';
  };
}
