# { config, pkgs, ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;

      character = {
        success_symbol = "[\\$](bold green)";
        error_symbol = "[\\$](bold red)";
      };

      aws.disabled = true;
      gcloud.disabled = true;
      git_branch.disabled = true;
      git_status.disabled = true;
      package.disabled = true;
      nix_shell.format = "[$symbol $state]($style) ";
      nix_shell.symbol = "❄️";

      direnv = {
        format = "[$symbol$loaded/$allowed]($style) ";
        disabled = false;
        allowed_msg = "✅";
        not_allowed_msg = "🚫";
        loaded_msg = "🚚";
        unloaded_msg = "🛻";
      };
    };
  };
}
