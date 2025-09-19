# オフにしてるが、たぶんghostty-binをmacだけで使えばいけると思う
{
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = [
        "Mononoki Nerd Font"
        "ヒラギノ丸ゴ ProN"
      ];
      font-size = 15;
      font-feature = [
        "-calt"
        "-liga"
        "-dlig"
        "-ss20"
      ];
      palette = [
        "#7E7999"
      ];
      window-theme = "light";
      background-opacity = 0.9;
      macos-titlebar-style = "hidden";
      keybind = [
        "cmd+t=unbind"
        "cmd+w=unbind"
        "cmd+n=unbind"
        "cmd+c=unbind"
        "ctrl+c=unbind"
        "cmd+opt+left=unbind"
        "cmd+opt+right=unbind"
        "shift+enter=text:\n"
        "cmd+k=scroll_page_up"
        "cmd+j=scroll_page_down"
      ];
    };
  };
}
