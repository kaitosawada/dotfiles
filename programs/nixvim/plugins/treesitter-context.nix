{
  # https://nix-community.github.io/nixvim/plugins/treesitter-context/index.html
  plugins.treesitter-context = {
    enable = true;
    lazyLoad = {
      enable = true;
      settings.event = [
        "BufReadPost"
        "BufNewFile"
      ];
    };
  };
}
