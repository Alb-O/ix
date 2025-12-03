/*
  Flake outputs entry point
  This file is referenced by the auto-generated flake.nix

  imp auto-loads from outputs/ directory:
    - outputs/systems.nix      -> systems
    - outputs/perSystem/*.nix  -> perSystem.*
    - outputs/*.nix            -> flake.*
*/
inputs:
let
  inherit (inputs) nixpkgs flake-parts imp;
in
flake-parts.lib.mkFlake { inherit inputs; } {
  imports = [ imp.flakeModules.default ];

  # imp configuration - directory structure defines the flake
  imp = {
    src = ../outputs;

    # Extra args available in all output files
    args.nixpkgs = nixpkgs;

    # Registry: reference modules by name instead of path
    registry.src = ./..;

    # Auto-generate flake.nix from __inputs declarations
    flakeFile = {
      enable = true;
      coreInputs = import ./inputs.nix;
      description = "NixOS + Home Manager configuration using imp";
      outputsFile = "./nix/flake";
    };
  };
}
