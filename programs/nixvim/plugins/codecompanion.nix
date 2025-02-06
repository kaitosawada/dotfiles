{
  plugins.codecompanion = {
    enable = true;
    settings = {
      adapters = {
        openai = {
          __raw = ''
            function()
              return require("codecompanion.adapters").extend("openai", {
                env = {
                  api_key = function(self)
                    return _G.openai_api_key
                  end,
                },
                schema = {
                  model = {
                    default = "o1-mini",
                  },
                },
              })
            end
          '';
        };
        anthropic = {
          __raw = ''
            function()
              return require("codecompanion.adapters").extend("anthropic", {
                env = {
                  api_key = function(self)
                    return _G.anthropic_api_key
                  end,
                },
                schema = {
                  model = {
                    default = "claude-3-5-sonnet-20241022",
                  },
                },
              })
            end
          '';
        };

      };
      opts = {
        send_code = true;
        language = "Japanese";
      };
      display = {
        action_palette = {
          width = 95;
          height = 10;
          prompt = "Prompt ";
          provider = "telescope";
          opts = {
            show_default_actions = true;
            show_default_prompt_library = true;
          };
        };
        chat = {
          window = {
            layout = "vertical";
            position = "right";
            border = "single";
            height = 0.8;
            width = 0.45;
            relative = "editor";
          };
        };
      };
      strategies = {
        agent = {
          adapter = "openai";
        };
        chat = {
          adapter = "anthropic";
        };
        inline = {
          adapter = "anthropic";
        };
      };
    };
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>u";
      action = "<CMD>CodeCompanionChat<CR>";
      options = {
        desc = "Code Companion Chat";
      };
    }
  ];
}
