{ ... }:
{
  imports = [
    # ./awscli.nix
    ./bash.nix
    ./bat.nix
    ./direnv.nix
    ./fzf.nix
    ./gh.nix
    # ./ghostty.nix
    ./git.nix
    ./karabiner.nix
    ./lazygit.nix
    ./lsd.nix
    ./nvim-minimal.nix
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
