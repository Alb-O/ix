# Per-system formatter
{ pkgs, treefmt-nix, ... }:
let
  treefmtEval = treefmt-nix.lib.evalModule pkgs {
    projectRootFile = "flake.nix";
    programs.nixfmt.enable = true;
  };
in
treefmtEval.config.build.wrapper
