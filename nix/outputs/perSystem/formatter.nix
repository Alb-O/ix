{
  __inputs.treefmt-nix.url = "github:numtide/treefmt-nix";

  __functor =
    _:
    { pkgs, inputs, ... }:
    let
      treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
      };
    in
    treefmtEval.config.build.wrapper;
}
