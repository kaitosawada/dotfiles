{
  plugins.copilot-lua = {
    enable = true;
    settings = {
      suggestion = {
        enabled = true;
        auto_trigger = true;
        keymap = {
          accept = "<Tab>";
          next = "<M-]>";
          prev = "<M-[>";
          dismiss = "<C-]>";
        };
      };
    };
  };
}
