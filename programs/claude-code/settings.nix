{
  home.file.".claude/settings.json".text = ''
    {
      "permissions": {
        "allow": [
          "Bash(npm run lint)",
          "Bash(npm run test:*)",
          "Read(~/.zshrc)"
        ],
        "deny": []
      },
      "env": {
      }
    }
  '';
}
