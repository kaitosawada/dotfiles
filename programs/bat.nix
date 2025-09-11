{ ... }:
{
  programs.bat = {
    enable = true;
    config.theme = "nightfox";
    themes = {
      nightfox = {
        src = ../themes;
        file = "nightfox.tmTheme";
      };
    };
  };
}
