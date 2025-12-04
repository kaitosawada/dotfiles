{ username, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      core.editor = "nvim-minimal";
      user = {
        name = username;
        email = "75603046+kaitosawada@users.noreply.github.com";
      };
      pull.rebase = false;
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
    };
  };
}
