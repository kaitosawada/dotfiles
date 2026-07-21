{ inputs, ... }:
{
  imports = [
    # ./aerc.nix
    # ./awscli.nix
    ./bash.nix
    ./bat.nix
    ./colima.nix
    # ./direnv.nix
    ./fzf.nix
    ./gh.nix
    ./gh-dash.nix
    # ./ghostty.nix
    ./git.nix
    ./herdr

    ./java.nix
    ./karabiner.nix
    ./lazygit.nix
    ./lsd.nix
    # ./notmuch.nix
    ./nvim-minimal.nix
    # ./omp.nix
    ./opencode.nix
    # ./pi
    ./rclone.nix
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

  programs.nixvim = import ./nixvim { inherit inputs; };
}
