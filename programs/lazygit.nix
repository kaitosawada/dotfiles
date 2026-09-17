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
        edit = "lazygit-editor {{filename}}";
        editAtLine = "lazygit-editor {{filename}} {{line}}";
      };
      refresher = {
        externalChangeCheckInterval = 2;
        fetchInterval = 60;
        refreshInterval = 10;
      };
      services = {
        "git.ozonehl.dev" = "gitea:git.ozonehl.dev";
      };
    };
  };
}
