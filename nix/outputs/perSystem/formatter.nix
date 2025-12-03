# Formatter using treefmt-nix
{
  __inputs.treefmt-nix.url = "github:numtide/treefmt-nix";

  __functor =
    _:
    { pkgs, inputs, ... }:
    (inputs.treefmt-nix.lib.evalModule pkgs {
      projectRootFile = "flake.nix";
      programs.nixfmt.enable = true;
    }).config.build.wrapper;
}
