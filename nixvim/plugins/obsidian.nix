{
  plugsins.obsidian = {
    enable = true;
    settings = {
      workspaces = [
        {
          name = "personal";
          path = "~/obsidian/kaitosawada";
        }
      ];
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>on";
      action = "<cmd>ObsidianNew<CR>";
      options = {
        desc = "Obsidian: New Note";
      };
    }
    {
      mode = "n";
      key = "<leader>oo";
      action = "<cmd>ObsidianOpen<CR>";
      options = {
        desc = "Obsidian: Open Application";
      };
    }
    {
      mode = "n";
      key = "<leader>od";
      action = "<cmd>ObsidianToday<CR>";
      options = {
        desc = "Obsidian: Open Today's Daily Note";
      };
    }
    {
      mode = "n";
      key = "<leader>oy";
      action = "<cmd>ObsidianYesterday<CR>";
      options = {
        desc = "Obsidian: Open Yesterday's Daily Note";
      };
    }
    {
      mode = "n";
      key = "<leader>ot";
      action = "<cmd>ObsidianTomorrow<CR>";
      options = {
        desc = "Obsidian: Open Tomorrow's Daily Note";
      };
    }
    {
      mode = "n";
      key = "<leader>os";
      action = "<cmd>ObsidianSearch<CR>";
      options = {
        desc = "Obsidian: Search";
      };
    }
  ];
}
