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
      ui = {
        enable = false;
      };
      legacy_commands = false;
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>on";
      action = "<cmd>Obsidian new<CR>";
      options = {
        desc = "Obsidian: New Note";
      };
    }
    {
      mode = "n";
      key = "<leader>oo";
      action = "<cmd>Obsidian open<CR>";
      options = {
        desc = "Obsidian: Open Application";
      };
    }
    {
      mode = "n";
      key = "<leader>od";
      action = "<cmd>Obsidian today<CR>";
      options = {
        desc = "Obsidian: Open Today's Daily Note";
      };
    }
    {
      mode = "n";
      key = "<leader>oy";
      action = "<cmd>Obsidian yesterday<CR>";
      options = {
        desc = "Obsidian: Open Yesterday's Daily Note";
      };
    }
    {
      mode = "n";
      key = "<leader>ot";
      action = "<cmd>Obsidian tomorrow<CR>";
      options = {
        desc = "Obsidian: Open Tomorrow's Daily Note";
      };
    }
    {
      mode = "n";
      key = "<leader>os";
      action = "<cmd>Obsidian search<CR>";
      options = {
        desc = "Obsidian: Search";
      };
    }
    {
      mode = "n";
      key = "<leader>d";
      action = "<cmd>Obsidian dailies<CR>";
      options = {
        desc = "Obsidian: Search Daily Notes";
      };
    }
  ];
}
