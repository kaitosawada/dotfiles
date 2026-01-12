{
  programs.lazygit = {
    enable = true;
    settings = {
      os = {
        edit = ''nvim --server "$NVIM" --remote-send "<C-\><C-n>:bd!<CR>:e {{filename}}<CR>"'';
        editAtLine = ''nvim --server "$NVIM" --remote-send "<C-\><C-n>:bd!<CR>:e +{{line}} {{filename}}<CR>"'';
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
