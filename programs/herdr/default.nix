{ ... }:
{
  programs.herdr = {
    enable = true;
    settings = {
      keys = {
        # Custom commands ([[keys.command]] in TOML). Requires:
        #   herdr plugin install andrewchng/herdr-sessionizer --yes
        # (macOS only; needs bun + fzf on PATH)
        command = [
          {
            key = "prefix+p";
            type = "plugin_action";
            command = "sessionizer.open";
            description = "open project workspace (ghq/fzf)";
          }
        ];
        cycle_pane_next = [
          "ctrl+j"
        ];
        cycle_pane_previous = [
          "ctrl+k"
        ];
        next_workspace = [
          "ctrl+shift+j"
        ];
        previous_workspace = [
          "ctrl+shift+k"
        ];
        # Free prefix+g for sessionizer (default goto is prefix+g)
        goto = "prefix+shift+g";
        new_tab = [
          "prefix+c"
          "cmd+t"
        ];
        next_tab = [
          "ctrl+l"
        ];
        prefix = "ctrl+f";
        previous_tab = [
          "ctrl+h"
        ];
        split_vertical = [
          "prefix+v"
          "cmd+n"
        ];
        workspace_picker = [
          "prefix+w"
          "ctrl+w"
        ];
      };
    };
  };

  # Reference tree for the default layout. switch-project.sh builds this via
  # sequential pane splits (layout.apply leaves nvim with a full-client PTY size).
  home.file.".config/herdr/layouts/default.json" = {
    source = ./layouts/default.json;
  };

  # Managed sessionizer plugin config (install plugin separately; see AGENTS.md)
  home.file.".config/herdr/plugins/config/sessionizer/config.toml" = {
    source = ./sessionizer/config.toml;
  };
}
