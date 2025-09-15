{ lib, ... }:
let
  # ./nvim/scripts ディレクトリ内のファイル一覧を attrset として読む
  scriptsDir = builtins.readDir ../../../overseer-template;

  # ファイル名だけを取り出し（ディレクトリは除外）、拡張子を削除
  scriptNames = map (name: lib.strings.removeSuffix ".lua" name) (
    builtins.filter (name: scriptsDir.${name} == "regular") (builtins.attrNames scriptsDir)
  );
in
{
  plugins.overseer = {
    enable = true;
    settings = {
      templates = [
        "builtin"
      ]
      ++ scriptNames;
    };
  };
  keymaps = [
    {
      mode = [ "n" ];
      key = "<leader>ct";
      action = ":OverseerToggle<cr>";
      options = {
        desc = "Overseer: Toggle";
        noremap = true;
        silent = true;
      };
    }
    {
      mode = [ "n" ];
      key = "<leader>cr";
      action = ":OverseerRun<cr>";
      options = {
        desc = "Overseer: Run";
        noremap = true;
        silent = true;
      };
    }
  ];
}
