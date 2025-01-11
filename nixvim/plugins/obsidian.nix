{
  # https://github.com/epwalsh/obsidian.nvim?tab=readme-ov-file#demo
  plugins.obsidian = {
    enable = true;
    settings = {
      workspaces = [
        {
          name = "personal";
          path = "~/obsidian/kaitosawada";
        }
      ];
      daily_notes = {
        folder = "daily";
      };
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
      key = "<leader>og";
      action = "<cmd>ObsidianSearch<CR>";
      options = {
        desc = "Obsidian: Search";
      };
    }
    {
      mode = "n";
      key = "<leader>os";
      action = "<cmd>ObsidianDailies<CR>";
      options = {
        desc = "Obsidian: Search Daily Notes";
      };
    }
    {
      mode = "v";
      key = "<leader>ol";
      action = "<cmd>ObsidianLinkNew<CR>";
      options = {
        desc = "Obsidian: Search Daily Notes";
      };
    }
  ];
}
