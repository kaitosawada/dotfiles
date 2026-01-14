{ ... }:
{
  imports = [
    # ./aerc.nix
    # ./awscli.nix
    ./bash.nix
    ./bat.nix
    ./direnv.nix
    ./fzf.nix
    ./gh.nix
    ./gh-dash.nix
    # ./ghostty.nix
    ./git.nix
    ./karabiner.nix
    ./lazygit.nix
    ./lsd.nix
    # ./notmuch.nix
    ./nvim-minimal.nix
    ./ssh.nix
    ./starship.nix
    ./syncthing.nix
    ./tmux.nix
    ./wezterm
    ./yazi.nix
    ./zellij
    ./zoxide.nix
    ./zsh.nix
  ];

  programs.nixvim = import ./nixvim;
}
