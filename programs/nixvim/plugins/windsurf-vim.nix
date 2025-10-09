{
  # blink-cmpに対応しているのがwindsurf.nvimだったので利用している
  # windsurf.vimの方が微妙に開発が活発かもしれない
  plugins.windsurf-nvim = {
    enable = true;
    settings = {
      enable_cmp_source = false;
    };
  };
}
