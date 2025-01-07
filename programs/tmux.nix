{
  # config,
  pkgs,
  ...
}:
{
  programs.tmux = {
    enable = true;
    prefix = "C-f";
    keyMode = "vi";
    terminal = "tmux-256color";
    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      {
        plugin = tmuxPlugins.tokyo-night-tmux;
        extraConfig = ''
          set -g @tokyo-night-tmux_theme storm    # storm | day | default to 'night'
          set -g @tokyo-night-tmux_transparent 0  # 1 or 0
          set -g @tokyo-night-tmux_show_datetime 0
          set -g @tokyo-night-tmux_date_format MYD
          set -g @tokyo-night-tmux_time_format 12H
        '';
      }
      # {
      #   plugin = pkgs.tmuxPlugins.catppuccin;
      #   extraConfig = ''
      #     set -g @catppuccin_flavour 'frappe'
      #     set -g @catppuccin_window_tabs_enabled on
      #     set -g @catppuccin_date_time "%H:%M"
      #   '';
      # }
    ];
    extraConfig = ''
      set -g status-left "#S "

      bind -n C-t new-window -c "#{pane_current_path}"
      bind -n C-q confirm-before 'kill-window'

      bind -n C-h previous-window
      bind -n C-l next-window

      bind -n C-- split-window -vc "#{pane_current_path}"
      bind -n C-| split-window -hc "#{pane_current_path}"

      bind -n C-k select-pane -t :.-
      bind -n C-j select-pane -t :.+
      bind -n C-w kill-pane
      bind -n C-y copy-mode
    '';
  };
}
