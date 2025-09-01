{
  plugins.codecompanion.enable = true;
  plugins.codecompanion.settings = {
    adapters = {
      openai = {
        __raw = ''
          function()
            return require("codecompanion.adapters").extend("openai", {
              schema = {
                model = {
                  default = "gpt-5"
                }
              }
            })
          end
        '';
      };
    };
    opts = {
      log_level = "TRACE";
      send_code = true;
      use_default_actions = true;
      use_default_prompts = true;
    };
    strategies = {
      agent = {
        adapter = "openai";
      };
      chat = {
        adapter = "openai";
      };
      inline = {
        adapter = "openai";
      };
    };
  };
}
