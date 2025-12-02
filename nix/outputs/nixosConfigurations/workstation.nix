{
  __inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  __functor =
    _:
    {
      inputs,
      lib,
      imp,
      ...
    }:
    lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs imp; };
      modules = [
        (imp.filterNot (lib.hasInfix "/config/") ../../hosts/workstation)
        (imp ../../modules/nixos)
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs imp; };
            users.alice = import ../../home/alice;
          };
        }
      ];
    };
}
