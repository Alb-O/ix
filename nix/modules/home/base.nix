# Shared Home Manager base
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gnumake
    gcc
    bat
    eza
    duf
  ];

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
      pager = "less -FR";
    };
  };
}
