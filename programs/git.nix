{ username, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      core.editor = "nvim-minimal";
      user = {
        name = username;
        email = "kaito.sawada@proton.me";
      };
      pull.rebase = false;
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
    };
  };
}
