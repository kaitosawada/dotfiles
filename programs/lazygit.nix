{
  programs.lazygit = {
    enable = true;
    settings = {
      customCommands = [
        {
          key = "c";
          context = "files";
          command = "git commit -v";
          description = "Commit changes using git editor";
          output = "terminal";
        }
      ];
      git = {
        autoDetectExternalChanges = true;
        autoFetch = true;
        autoRefresh = true;
      };
      os = {
        edit = "nvim --server /tmp/nvim-$ZELLIJ_SESSION_NAME.pipe --remote {{filename}}";
        editAtLine = "nvim --server /tmp/nvim-$ZELLIJ_SESSION_NAME.pipe --remote-send ':edit +{{line}} {{filename}}<CR>'";
      };
      refresher = {
        externalChangeCheckInterval = 2;
        fetchInterval = 60;
        refreshInterval = 10;
      };
    };
  };
}
