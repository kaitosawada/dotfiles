{
  # https://nix-community.github.io/nixvim/plugins/copilot-chat/index.html
  plugins.copilot-chat = {
    enable = true;
    settings = {
      model = "auto";
      # model = "qwen3.5-9b";
      providers = {
        local = {
          get_models = {
            __raw = ''
              function(headers)
                return { { id = "qwen3.5-9b", name = "qwen3.5-9b" } }
              end
            '';
          };
          get_url = {
            __raw = ''
              function(opts)
                return "http://localhost:1234/v1/chat/completions"
              end
            '';
          };
          prepare_input = {
            __raw = "require('CopilotChat.config.providers').copilot.prepare_input";
          };
          prepare_output = {
            __raw = "require('CopilotChat.config.providers').copilot.prepare_output";
          };
        };
      };
      prompts = {
        CommentsEdit = {
          prompt = "Modify the selected code according to the inline comments that describe the desired changes. Output only the modified code without any explanations.";
          mapping = "<leader>cc";
          description = "Modify code according to comments";
        };
      };
    };
  };
}
