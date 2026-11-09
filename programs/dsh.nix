{
  pkgs,
  system,
  inputs,
  ...
}:
let
  dsh = inputs.llm-agents.packages.${system}.dsh;
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "dsh" ''
      export EDITOR="nvim-minimal"
      exec ${dsh}/bin/dsh "$@"
    '')
  ];
}
