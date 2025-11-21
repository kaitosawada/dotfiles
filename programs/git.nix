{ username, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = username;
        email = "kaito.sawada@proton.me";
      };
      pull.rebase = false;
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
    };
  };
}
