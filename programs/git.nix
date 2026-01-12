{ username, homeDirectory, ... }:
let
  signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOnQQ7x8XAnirqz1MlR5kFbvZ5VL6MMaBZi5JmOdYEMB";
  email = "mitosawada@gmail.com";
  allowedSignersFile = "${homeDirectory}/.ssh/allowed_signers";
in
{
  programs.git = {
    enable = true;
    settings = {
      core.editor = "nvim-minimal";
      user = {
        name = username;
        inherit email signingkey;
      };
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = allowedSignersFile;
      commit.gpgsign = true;
      tag.gpgsign = true;
      pull.rebase = false;
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
    };
  };

  home.file.".ssh/allowed_signers".text = "${email} ${signingkey}";
}
