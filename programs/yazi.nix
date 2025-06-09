{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
    theme = {
      filetype = {
        rules = [
          {
            fg = "#7AD9E5";
            mime = "image/*";
          }
          {
            fg = "#F3D398";
            mime = "video/*";
          }
          {
            fg = "#F3D398";
            mime = "audio/*";
          }
          {
            fg = "#CD9EFC";
            mime = "application/bzip";
          }
        ];
      };
    };
    plugins = {
      smart-enter = pkgs.yaziPlugins.smart-enter;
      git = pkgs.yaziPlugins.git;
    };
    keymap = {
      manager.prepend_keymap = [
        {
          on = [ "<Enter>" ];
          run = "plugin smart-enter";
          desc = "Enter the child directory, or open the file";
        }
      ];
    };
  };
}
