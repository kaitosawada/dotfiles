# { config, pkgs, ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;

      character = {
        error_symbol = "[╰─ ](bold red)";
        success_symbol = "[╰─ ](bold green)";
        vimcmd_symbol = "[╰─󰩗 ](bold green)";
      };

      format = 
        "[╭───](green)"
        + "[$username](bg:green fg:black)"
        + "$directory"
        + "[ ](green)"
        + "$battery$all$line_break$character";
      # format =
      #   "[╭───](#9A348E)"
      #   + "$os"
      #   + "$username"
      #   + "[](bg:#DA627D fg:#9A348E)"
      #   + "$directory"
      #   + "[](fg:#DA627D bg:#FCA17D)"
      #   + "$git_branch"
      #   + "$git_status"
      #   + "[](fg:#FCA17D bg:#86BBD8)"
      #   + "$all"
      #   + "[](fg:#86BBD8 bg:#06969A)"
      #   + "$docker_context"
      #   + "[](fg:#06969A bg:#33658A)"
      #   + "$time"
      #   + "[ ](fg:#33658A)";

      # username = {
      #   show_always = true;
      #   style_user = "bg:#9A348E";
      #   style_root = "bg:#9A348E";
      #   format = "[$user ]($style)";
      #   disabled = false;
      # };
      #
      # os = {
      #   style = "bg:#9A348E";
      #   disabled = true;
      # };

      directory = {
        style = "bg:green fg:black";
        format = "[ $path ]($style)";
        # truncation_length = 3;
        # truncation_symbol = "…/";
      };

      # docker_context = {
      #   symbol = " ";
      #   style = "bg:#06969A";
      #   format = "[ $symbol $context ]($style)";
      # };
      #
      # battery = {
      #   full_symbol = "🔋";
      #   charging_symbol = "⚡️";
      #   unknown_symbol = "❓";
      #   empty_symbol = "🔌";
      #   disabled = false;
      #   format = "[ $symbol $percentage% ]($style)";
      #   style = "bg:#DA627D";
      # };
      #
      # time = {
      #   style = "bg:#33658A";
      #   format = "[ ♥ $time ]($style)";
      #   time_format = "%R";
      #   disabled = false;
      # };

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
