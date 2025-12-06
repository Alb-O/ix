# Formatter using imp.formatterLib
{
  __inputs.treefmt-nix.url = "github:numtide/treefmt-nix";

  __functor =
    _:
    { pkgs, inputs, ... }:
    inputs.imp.formatterLib.make {
      inherit pkgs;
      treefmt-nix = inputs.treefmt-nix;
    };
}
