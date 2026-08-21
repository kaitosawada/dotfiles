{ config, username, ... }:
let
  email = "75603046+kaitosawada@users.noreply.github.com";
in
{
  sops.secrets."forgejo-token" = {
    sopsFile = ../secrets/home.yaml;
  };

  sops.templates."git-credentials-forgejo" = {
    content = ''
      https://k.sawada:${config.sops.placeholder."forgejo-token"}@git.ozonehl.dev
    '';
    path = "${config.home.homeDirectory}/.config/git/credentials-forgejo";
  };

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
      url."https://git.ozonehl.dev/".insteadOf = [
        "git@git.ozonehl.dev:"
        "ssh://git@git.ozonehl.dev/"
      ];
      credential."https://git.ozonehl.dev".helper = "store --file ${
        config.sops.templates."git-credentials-forgejo".path
      }";
    };
  };
}
