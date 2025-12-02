# Flake outputs entry point
# This file is referenced by the auto-generated flake.nix
inputs:
let
  inherit (inputs)
    self
    nixpkgs
    flake-parts
    imp
    ;
  lib = nixpkgs.lib;
  impLib = imp.withLib lib;
in
flake-parts.lib.mkFlake { inherit inputs; } {
  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];

  imports = [ imp.flakeModules.default ];

  imp = {
    src = ../outputs;
    args = {
      inherit
        self
        inputs
        lib
        nixpkgs
        ;
      imp = impLib;
    };

    flakeFile = {
      enable = true;
      coreInputs = import ./inputs.nix;
      description = "NixOS + Home Manager configuration using imp";
      outputsFile = "./nix/flake";
    };
  };

  flake = {
    nixosModules = {
      default = imp ../modules/nixos;
      profiles = imp ../modules/profiles;
    };

    homeModules = {
      default = imp ../modules/home;
    };

    overlays.default = final: prev: {
      ix = self.packages.${prev.system} or { };
    };
  };
}
