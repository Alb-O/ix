{ pkgs, ... }:
{
  enable = true;
  profiles.default = {
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      vscodevim.vim
      dracula-theme.theme-dracula
    ];

    userSettings = {
      "editor.fontSize" = 14;
      "editor.tabSize" = 2;
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
    };
  };
}
