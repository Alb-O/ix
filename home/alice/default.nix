# Alice's Home Manager configuration
#
# This file sets home.* options directly.
# Programs and services are loaded via configTree from ./config:
#   config/programs/git.nix      -> programs.git = { ... }
#   config/services/syncthing.nix -> services.syncthing = { ... }
#
{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  imp = inputs.imp.withLib lib;
in
{
  imports = [
    # Load programs/* and services/* via configTree
    # Each file's path becomes its option path
    (imp.configTree ./config)
  ];

  home = {
    username = "alice";
    homeDirectory = "/home/alice";
    stateVersion = "24.05";

    # Default packages
    packages = with pkgs; [
      ripgrep
      fd
      jq
      htop
      tree
    ];
  };

  # XDG directories
  xdg.enable = true;
}
