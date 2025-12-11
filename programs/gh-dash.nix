{ ... }:
{
  programs.gh-dash = {
    enable = true;
    settings = {
      keybindings = {
        universal = [
          {
            key = "J";
            name = "preview page down";
            builtin = "pageDown";
          }
          {
            key = "K";
            name = "preview page up";
            builtin = "pageUp";
          }
          {
            key = "g";
            name = "lazygit";
            command = "lazygit";
          }
        ];
        prs = [
          {
            key = "H";
            name = "preview previous tab";
            builtin = "prevSidebarTab";
          }
          {
            key = "L";
            name = "preview next tab";
            builtin = "nextSidebarTab";
          }
        ];
      };
    };
  };
}
