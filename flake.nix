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
    {
      # NixOS configurations - each host imports modules via imp
      nixosConfigurations = {
        # Example workstation host
        workstation = lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            # Import host modules, excluding config/ (handled by configTree in default.nix)
            ((imp.withLib lib).filterNot (lib.hasInfix "/config/") ./hosts/workstation)

            # Import shared NixOS modules
            (imp ./modules/nixos)

            # Home Manager as NixOS module
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
                users.alice = import ./home/alice;
              };
            }
          ];
        };

        # Example server host
        server = lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            # Import host modules, excluding config/
            ((imp.withLib lib).filterNot (lib.hasInfix "/config/") ./hosts/server)
            (imp ./modules/nixos)

            # Server uses imp filtering for selective modules
            (
              let
                i = imp.withLib lib;
              in
              i.filter (lib.hasInfix "/server/") ./modules/profiles
            )
          ];
        };

        # QEMU VM for testing
        vm = lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            # Import host modules, excluding config/
            ((imp.withLib lib).filterNot (lib.hasInfix "/config/") ./hosts/vm)
            (imp ./modules/nixos)

            # Include Home Manager in VM for testing
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
                users.alice = import ./home/alice;
              };
            }
          ];
        };
      };

      # Standalone Home Manager configurations
      homeConfigurations = {
        "alice@workstation" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            # Import all home modules via imp
            (imp ./home/alice)
            (imp ./modules/home)
          ];
        };
      };

      # NixOS modules exposed for external use
      nixosModules = {
        default = imp ./modules/nixos;
        profiles = imp ./modules/profiles;
      };

      # Home Manager modules exposed for external use
      homeModules = {
        default = imp ./modules/home;
      };
    }
    # Per-system outputs using flake-utils
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        args = {
          inherit
            self
            pkgs
            inputs
            treefmt-nix
            ;
        };
        # Use imp.treeWith to load per-system outputs from ./outputs
        outputs = imp.treeWith lib (f: f args) ./outputs;
      in
      outputs
    )
    // {
      # Overlay combining all packages (system-independent)
      overlays.default = final: prev: {
        ix =
          let
            pkgs = nixpkgs.legacyPackages.${prev.system};
            args = {
              inherit
                self
                pkgs
                inputs
                treefmt-nix
                ;
            };
          in
          (imp.treeWith lib (f: f args) ./outputs).packages or { };
      };
    };
}
