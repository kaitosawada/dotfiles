{ username, ... }:
let
  email = "75603046+kaitosawada@users.noreply.github.com";
in
{
  programs.git = {
    enable = true;
    settings = {
      core.editor = "nvim-minimal";
      user = {
        name = username;
        inherit email;
      };
      # NOTE: ssh rewriteなんでやってたんだっけ？
      # url."ssh://git@github.com/".insteadOf = "https://github.com/";
      pull.rebase = true;
      fetch.prune = true;
      ghq.root = "~/ghq";
    };
  };
}
