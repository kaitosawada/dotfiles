{
  inputs,
  system,
  ...
}:
{
  home.packages = [
    inputs.llm-agents.packages.${system}.cursor-agent
  ];
}
