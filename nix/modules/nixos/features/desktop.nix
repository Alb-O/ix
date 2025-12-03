# Desktop environment feature
# Bundles fonts, flatpak, and printing for a complete desktop experience
{ pkgs, ... }:
{
  # Flatpak for sandboxed GUI apps
  services.flatpak.enable = true;

  # Font configuration
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      fira-code
      fira-code-symbols
      nerd-fonts.fira-code
    ];
    fontconfig.defaultFonts = {
      monospace = [ "FiraCode Nerd Font" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };
  };

  # Printing support
  services.printing.enable = true;
}
