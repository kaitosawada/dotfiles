{
  plugins.copilot-chat = {
    enable = true;
    settings = {
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
