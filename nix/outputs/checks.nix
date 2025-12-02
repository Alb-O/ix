# Per-system checks
{
  self,
  pkgs,
  treefmt-nix,
  ...
}:
let
  treefmtEval = treefmt-nix.lib.evalModule pkgs {
    projectRootFile = "flake.nix";
    programs.nixfmt.enable = true;
  };
in
{
  formatting = treefmtEval.config.build.check self;
}
