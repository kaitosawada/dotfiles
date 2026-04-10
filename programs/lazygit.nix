{
  programs.lazygit = {
    enable = true;
    settings = {
      os = {
        edit = "nvim --server \"$NVIM\" --remote-send '<C-\\><C-n>:let buf=bufnr()<CR>:close<CR>:execute \"bd! \" . buf<CR>:execute \"edit \" . fnameescape({{filename}})<CR>'";
        editAtLine = "nvim --server \"$NVIM\" --remote-send '<C-\\><C-n>:let buf=bufnr()<CR>:close<CR>:execute \"bd! \" . buf<CR>:execute \"edit +\" . {{line}} . \" \" . fnameescape({{filename}})<CR>'";
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
