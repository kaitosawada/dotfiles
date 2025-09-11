{ username, ... }:
{
  programs.git = {
    enable = true;
    userName = username;
    userEmail = "kaito.sawada@proton.me";
    extraConfig = {
      pull.rebase = false;
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
    };
  };
}
