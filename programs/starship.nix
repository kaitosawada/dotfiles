{ homeDirectory, ... }:
{
  programs.zsh.initContent = ''
    # VSCode ターミナルでは starship を無効にする
    if [[ $TERM != "dumb" && $TERM_PROGRAM != "vscode" ]]; then
      eval "$(${homeDirectory}/.nix-profile/bin/starship init zsh)"
    fi
  '';
  programs.starship = {
    enable = true;
    enableZshIntegration = false;
    settings =
      {
        format =
          "[╭───](color_green)"
          + "$os"
          + "$username"
          + "[](bg:color_purple fg:color_green)"
          + "$directory"
          + "[](fg:color_purple bg:color_blue)"
          + "$c"
          + "$rust"
          + "$golang"
          + "$nodejs"
          + "$php"
          + "$java"
          + "$kotlin"
          + "$haskell"
          + "$python"
          + "[](fg:color_blue bg:color_bg3)"
          + "$nix_shell"
          + "$direnv"
          + "$docker_context"
          + "$conda"
          + "[](fg:color_bg3 bg:color_bg1)"
          + "$time"
          + "[ ](fg:color_bg1)"
          + "$line_break$character";

        palette = "gruvbox_dark";
        palettes = {
          gruvbox_dark = {
            color_fg0 = "#fbf1c7";
            color_bg1 = "#3c3836";
            color_bg3 = "#665c54";
            color_blue = "#458588";
            color_aqua = "#689d6a";
            color_green = "#98971a";
            color_orange = "#d65d0e";
            color_purple = "#b16286";
            color_red = "#cc241d";
            color_yellow = "#d79921";
          };
        };

        os = {
          disabled = false;
          format = "[$symbol ]($style)";
          style = "bg:color_green fg:color_fg0";
          symbols = {
            Windows = "󰍲";
            Ubuntu = "󰕈";
            SUSE = "";
            Raspbian = "󰐿";
            Mint = "󰣭";
            Macos = "󰀵";
            Manjaro = "";
            Linux = "󰌽";
            Gentoo = "󰣨";
            Fedora = "󰣛";
            Alpine = "";
            Amazon = "";
            Android = "";
            Arch = "󰣇";
            Artix = "󰣇";
            EndeavourOS = "";
            CentOS = "";
            Debian = "󰣚";
            Redhat = "󱄛";
            RedHatEnterprise = "󱄛";
            Pop = "";
          };
        };

        username = {
          style_user = "bg:color_green fg:color_fg0";
          style_root = "bg:color_green fg:color_fg0";
          format = "[$user ]($style)";
        };

        directory = {
          style = "fg:color_fg0 bg:color_purple";
          format = "[ $path ]($style)";
          substitutions = {
            Documents = "󰈙 ";
            Downloads = " ";
            Music = "󰝚 ";
            Pictures = " ";
            Developer = "󰲋 ";
          };
        };

        nodejs = {
          symbol = "";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };

        c = {
          symbol = " ";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };

        rust = {
          symbol = "";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };

        golang = {
          symbol = "";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };

        php = {
          symbol = "";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };

        java = {
          symbol = "";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };

        kotlin = {
          symbol = "";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };

        haskell = {
          symbol = "";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };

        python = {
          symbol = "";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };

        docker_context = {
          symbol = "";
          style = "bg:color_bg3";
          format = "[[ $symbol( $context) ](fg:#83a598 bg:color_bg3)]($style)";
        };

        conda = {
          style = "bg:color_bg3";
          format = "[[ $symbol( $environment) ](fg:#83a598 bg:color_bg3)]($style)";
        };

        time = {
          disabled = false;
          time_format = "%R";
          style = "bg:color_bg1";
          format = "[[  $time ](fg:color_fg0 bg:color_bg1)]($style)";
        };
      }
      // {
        add_newline = true;

        character = rec {
          # "[╭───](color_green)"
          error_symbol = "[╰─ ](bold color_red)";
          success_symbol = "[╰─ ](bold color_green)";
          vimcmd_symbol = "[╰─ ](bold color_purple)";
          vimcmd_replace_one_symbol = vimcmd_symbol;
          vimcmd_replace_symbol = vimcmd_symbol;
          vimcmd_visual_symbol = vimcmd_symbol;
        };

        aws.disabled = true;
        gcloud.disabled = true;
        git_branch.disabled = true;
        git_status.disabled = true;
        package.disabled = true;

        nix_shell = {
          symbol = "❄️";
          style = "bg:color_blue";
          format = "[[ $symbol](fg:#83a598 bg:color_bg3)]($style)";
          # nix_shell.format = "[$symbol $state]($style) ";
        };

        direnv = {
          format = "[[ $symbol$loaded/$allowed ](fg:#83a598 bg:color_bg3)]($style)";
          disabled = false;
          allowed_msg = "";
          denied_msg = "";
          loaded_msg = " ";
          unloaded_msg = " ";
        };
      };
  };
}
