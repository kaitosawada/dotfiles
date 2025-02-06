{
  plugins.avante = {
    enable = true;
    # lazyLoad = {
    #   settings = {
    #     keys = [
    #       "<leader>a"
    #     ];
    #     ft = [
    #       "python"
    #       "lua"
    #       "nix"
    #       "go"
    #       "rust"
    #     ];
    #   };
    # };
    settings = {
      provider = "openai";
      openai = {
        api_key_name = "cmd:bw get notes openai-api-key --nointeraction";
      };
      mappings = {
        submit = {
          normal = "<CR>";
          insert = "<C-CR>";
        };
      };
      windows = {
        ask = {
          floating = true;
        };
      };
    };
  };
}
