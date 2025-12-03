# Flake checks
{
  __inputs.treefmt-nix.url = "github:numtide/treefmt-nix";

  __functor =
    _:
    {
      self,
      pkgs,
      inputs,
      ...
    }:
    {
      formatting =
        (inputs.treefmt-nix.lib.evalModule pkgs {
          projectRootFile = "flake.nix";
          programs.nixfmt.enable = true;
        }).config.build.check
          self;
    };
}
