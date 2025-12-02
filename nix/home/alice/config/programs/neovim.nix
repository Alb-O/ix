{ pkgs, ... }:
{
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;

  extraPackages = with pkgs; [
    # LSP servers
    nil
    lua-language-server
    nodePackages.typescript-language-server

    # Formatters
    nixfmt-rfc-style
    stylua

    # Tools
    ripgrep
    fd
  ];
}
