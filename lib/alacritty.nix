{ alacritty, ... }:
{
  enable = true;
  package = alacritty;
  settings = {
    window.padding = {
      x = 10;
      y = 10;
    };
    scrolling = {
      history = 5000;
    };
    font = {
      size = 12;
      # draw_bold_text_with_bright_colors = true;
      normal = {
        family = "SauceCodePro Nerd Font";
        style = "Regular";
      };
      bold = {
        family = "SauceCodePro Nerd Font";
        style = "Bold";
      };
    };
  };
}
