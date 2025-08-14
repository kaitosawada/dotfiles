{ ... }:
{
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      ${builtins.readFile ../scripts/init-nix.sh}
      ${builtins.readFile ../scripts/switch-project.sh}
    '';
  };
}
