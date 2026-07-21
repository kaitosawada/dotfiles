{ ... }:
{
  programs.herdr = {
    enable = true;
    settings = {
      keys = {
        cycle_pane_next = [
          "ctrl+j"
        ];
        cycle_pane_previous = [
          "ctrl+k"
        ];
        new_tab = [
          "prefix+c"
          "cmd+t"
        ];
        next_tab = [
          "prefix+n"
          "ctrl+l"
        ];
        prefix = "ctrl+f";
        previous_tab = [
          "prefix+p"
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

  home.file.".config/herdr/layouts/default.json" = {
    source = ./layouts/default.json;
  };
}
