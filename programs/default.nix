{ ... }:
{
  imports = [
    ./aerc.nix
    # ./awscli.nix
    ./bash.nix
    ./bat.nix
    ./direnv.nix
    ./fzf.nix
    ./gh.nix
    ./gh-dash.nix
    # ./ghostty.nix
    ./git.nix
    ./himalaya.nix
    ./karabiner.nix
    ./lazygit.nix
    ./lsd.nix
    ./notmuch.nix
    ./nvim-minimal.nix
    ./ssh.nix
    ./starship.nix
    ./tmux.nix
    ./wezterm
    ./yazi.nix
    ./zellij
    ./zoxide.nix
    ./zsh.nix
  ];

  programs.nixvim = import ./nixvim;
}
