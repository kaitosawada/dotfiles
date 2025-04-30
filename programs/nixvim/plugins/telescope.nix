{ pkgs, ... }:
let
  smart-open = pkgs.vimUtils.buildVimPlugin {
    name = "smart-open";
    src = pkgs.fetchFromGitHub {
      owner = "danielfalk";
      repo = "smart-open.nvim";
      rev = "7770b01ce4d551c143d7ec8589879320796621b9";
      hash = "sha256-cnWB5Op48wkSFZM5TcNVUVGp77PN6dZ6al1RsBEL3/s=";
    };
    dependencies = with pkgs.vimPlugins; [
      telescope-nvim
      sqlite-lua
      plenary-nvim
      fzf-lua
      telescope-fzf-native-nvim
    ];
  };
in
{
  # https://nix-community.github.io/nixvim/plugins/telescope/index.html
  plugins.telescope = {
    enable = true;
    keymaps = {
      # "<leader>f" = "find_files";
      "<leader>f" = "smart_open";
      "<leader>g" = "live_grep";
      "<leader>td" = "resume";
      "<leader>tb" = "buffers";
      "<leader>th" = "help_tags";
      "<leader>tr" = "registers";
      "<leader>tc" = "commands";
      "<leader>tn" = "noice";
    };
    extensions.fzf-native.enable = true;
    enabledExtensions = [
      "smart_open"
      "noice"
    ];
    settings.defaults.mappings.i = {
      "<C-u>" = false;
    };
  };

  extraPlugins = [
    smart-open
  ];

  keymaps = [
    {
      mode = [
        "v"
      ];
      key = "<leader>g";
      action = "\"ay<cmd>Telescope live_grep<cr><C-r>a";
      options = {
        desc = "Telescope: live_grep";
        noremap = false;
        silent = false;
      };
    }
    {
      mode = [
        "n"
      ];
      key = "<leader>tq";
      action = "<cmd>Telescope quickfix<cr>";
      options = {
        desc = "Telescope: quickfix";
        noremap = false;
        silent = false;
      };
    }
  ];
}
