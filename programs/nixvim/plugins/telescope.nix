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
  # https://github.com/nvim-telescope/telescope-live-grep-args.nvim?tab=readme-ov-file#grep-argument-examples
  telescope-live-grep-args = pkgs.vimUtils.buildVimPlugin {
    name = "telescope-live-grep-args";
    src = pkgs.fetchFromGitHub {
      owner = "nvim-telescope";
      repo = "telescope-live-grep-args.nvim";
      rev = "b80ec2c70ec4f32571478b501218c8979fab5201";
      hash = "sha256-VmX7K21v3lErm7f5I7/1rJ/+fSbFxZPrbDokra9lZpQ=";
    };
    dependencies = with pkgs.vimPlugins; [
      telescope-nvim
      plenary-nvim
    ];
  };
  grep_additional_args = [
    "--hidden"
    "--glob"
    "!.git/"
    "--glob"
    "!node_modules/"
    "--glob"
    "!.next/"
    "--glob"
    "!dist/"
    "--glob"
    "!build/"
    "--glob"
    "!pnpm-lock.yaml"
    "--glob"
    "!package-lock.json"
    "--glob"
    "!yarn.lock"
  ];
  grep_additional_args_lua =
    "{ " + builtins.concatStringsSep ", " (map (x: ''"${x}"'') grep_additional_args) + " }";
in
{
  # https://nix-community.github.io/nixvim/plugins/telescope/index.html
  plugins.telescope = {
    enable = true;
    lazyLoad = {
      enable = true;
      settings = {
        cmd = [ "Telescope" ];
      };
    };
    keymaps = {
      # "<leader>f" = "find_files";
      # "<leader>f" = "smart_open";
      # "<leader>g" = "live_grep";
      "<leader>td" = "resume";
      "<leader>tb" = "buffers";
      "<leader>th" = "help_tags";
      "<leader>tr" = "registers";
      "<leader>tc" = "commands";
      "<leader>tn" = "noice";

      # lsp
      "gd" = "lsp_definitions";
      "gD" = "lsp_references";
      "gt" = "lsp_type_definitions";
      "gi" = "lsp_implementations";
    };
    extensions = {
      fzf-native.enable = true;
      ui-select.enable = true;
    };
    enabledExtensions = [
      "live_grep_args"
      "smart_open"
      "noice"
    ];
    settings = {
      defaults.mappings.i = {
        "<C-u>" = false;
        "<C-f>" = {
          __raw = ''require("telescope.actions").send_to_qflist + require("telescope.actions").open_qflist'';
        };
      };

      pickers = {
        live_grep = {
          additional_args = grep_additional_args;
        };
      };

      extensions = {
        live_grep_args = {
          auto_quoting = true;
        };
      };
    };
  };

  extraPlugins = [
    smart-open
    telescope-live-grep-args
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
      key = "<leader>g";
      action = "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args({ additional_args = ${grep_additional_args_lua} })<cr>";
      options = {
        desc = "Telescope: live_grep_args";
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
    {
      mode = [
        "n"
      ];
      key = "<leader>f";
      action = "<cmd>lua require('telescope').extensions.smart_open.smart_open({ cwd_only = true })<cr>";
      options = {
        desc = "Telescope: smart_open";
        noremap = false;
        silent = false;
      };
    }
  ];
}
