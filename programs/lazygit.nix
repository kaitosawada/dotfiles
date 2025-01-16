{
  programs.lazygit = {
    enable = true;
    settings = {
      customCommands = [
        {
          key = "C";
          context = "files";
          command = "git commit -v -t ~/.config/git/commit_template_with_prompt.txt";
          description = "Commit changes using git editor";
          subprocess = true;
        }
      ];
    };

  };
}
