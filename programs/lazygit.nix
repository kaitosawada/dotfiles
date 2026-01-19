{
  programs.lazygit = {
    enable = true;
    settings = {
      os = {
        edit = "nvim --server \"$NVIM\" --remote-send '<C-\\><C-n>:bd!<CR>:execute \"edit \" .. {{filename}}<CR>'";
        editAtLine = "nvim --server \"$NVIM\" --remote-send '<C-\\><C-n>:bd!<CR>:execute \"edit +{{line}} \" .. {{filename}}<CR>'";
      };
      customCommands = [
        {
          key = "c";
          context = "files";
          command = "git commit -v";
          description = "Commit changes using git editor";
          output = "terminal";
        }
      ];
    };

  };
}
