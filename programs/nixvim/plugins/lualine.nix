{
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        # theme = "catppuccin";
        sectionSeparators = [
          ""
          ""
        ];
        componentSeparators = [
          ""
          ""
        ];
        path = 1;
        iconsEnabled = true;
      };
      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [ "branch" ];
        lualine_c = [ "filename" ];
        lualine_x = [
          "fileformat"
          "filetype"
        ];
        lualine_y = [ "progress" ];
        lualine_z = [ "location" ];
      };
      inactiveSections = {
        lualine_a = [ ];
        lualine_b = [ ];
        lualine_c = [ "filename" ];
        lualine_x = [ "location" ];
        lualine_y = [ ];
        lualine_z = [ ];
      };
      # tabline = [];
      extensions = [
        "fugitive"
        "nvim-tree"
      ];
    };
  };
}
