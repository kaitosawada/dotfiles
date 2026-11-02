{
  lib,
  ...
}:
let
  skillsDir = ../lib/SKILLS;

  # Every directory under lib/SKILLS/<name>/ containing SKILL.md is one skill.
  skillNames = builtins.attrNames (
    lib.filterAttrs (_: type: type == "directory" || type == "symlink") (builtins.readDir skillsDir)
  );

  mkSkillEntry = baseDir: skillName: {
    name = "${baseDir}/${skillName}";
    value.source = skillsDir + "/${skillName}";
  };
in
{
  # Claude Code discovers global skills under ~/.claude/skills
  home.file = builtins.listToAttrs (map (mkSkillEntry ".claude/skills") skillNames);

  # OpenCode discovers global skills under ~/.config/opencode/skills
  xdg.configFile = builtins.listToAttrs (map (mkSkillEntry "opencode/skills") skillNames);
}
