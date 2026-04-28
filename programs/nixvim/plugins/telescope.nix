{ pkgs, ... }:
let
  smart-open = pkgs.vimUtils.buildVimPlugin {
    pname = "smart-open";
    version = "unstable";
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
    pname = "telescope-live-grep-args";
    version = "unstable";
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
        # skkeletonのCR挙動はextraConfigLuaのTextChangedI autocmdで
        # ▽/▼の有無に応じてkakutei/disableを事前に切り替え済み。
        # Telescopeのデフォルト(select_default)をそのまま使う。
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

  # Telescopeプロンプトでskkeletonの<CR>挙動を動的に切り替える。
  # ▽/▼あり → kakutei(確定のみ、改行なし)
  # ▽/▼なし → disable(skkeletonを通さずvim/telescopeに<CR>を渡す)
  # Telescope終了時にnewline(通常動作)に復元。
  extraConfigLua = ''
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "TelescopePrompt",
      callback = function(args)
        local last_has_marker = false
        -- 初期状態: 変換なし → disable
        vim.fn["skkeleton#register_keymap"]("input", "<CR>", "disable")

        vim.api.nvim_create_autocmd("TextChangedI", {
          buffer = args.buf,
          callback = function()
            local lines = vim.api.nvim_buf_get_lines(args.buf, 0, 1, false)
            local prompt = lines[1] or ""
            local has_marker = prompt:find("▽") ~= nil or prompt:find("▼") ~= nil
            if has_marker ~= last_has_marker then
              last_has_marker = has_marker
              if has_marker then
                vim.fn["skkeleton#register_keymap"]("input", "<CR>", "kakutei")
              else
                vim.fn["skkeleton#register_keymap"]("input", "<CR>", "disable")
              end
            end
          end,
        })

        vim.api.nvim_create_autocmd("BufDelete", {
          buffer = args.buf,
          once = true,
          callback = function()
            vim.fn["skkeleton#register_keymap"]("input", "<CR>", "newline")
          end,
        })
      end,
    })
  '';

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
