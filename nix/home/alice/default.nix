{
  imp,
  pkgs,
  ...
}:
{
  imports = [ (imp.configTree ./config) ];

  home = {
    username = "alice";
    homeDirectory = "/home/alice";
    stateVersion = "24.05";

    packages = with pkgs; [
      ripgrep
      fd
      jq
      htop
      tree
    ];
  };

  xdg.enable = true;
}
