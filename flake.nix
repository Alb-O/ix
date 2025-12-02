{
  description = "NixOS + Home Manager configuration using imp";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    imp.url = "github:Alb-O/imp";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      imp,
      flake-utils,
      treefmt-nix,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
    in
    (imp.withLib lib).flakeOutputs {
      systems = flake-utils.lib.defaultSystems;
      pkgsFor = system: nixpkgs.legacyPackages.${system};
      args = {
        inherit
          self
          inputs
          imp
          lib
          nixpkgs
          home-manager
          treefmt-nix
          ;
      };
    } ./nix/outputs
    // {
      nixosModules = {
        default = imp ./nix/modules/nixos;
        profiles = imp ./nix/modules/profiles;
      };

      homeModules = {
        default = imp ./nix/modules/home;
      };

      overlays.default = final: prev: {
        ix = self.packages.${prev.system} or { };
      };
    };
}
