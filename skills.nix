{ inputs, ... }:
{
  programs.agent-skills = {
    enable = true;
    sources.anthropic = {
      path = inputs.anthropic-skills;
      subdir = "skills";
    };
    skills.enable = [
      "skill-creator"
      "mcp-builder"
      "pdf"
    ];
    targets.claude.enable = true;
  };
}
