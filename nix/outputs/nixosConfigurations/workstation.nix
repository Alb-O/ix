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
      registry,
      ...
    }:
    lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs imp; };
      modules = [
        (imp.filterNot (lib.hasInfix "/config/") registry.hosts.workstation)
        (imp registry.modules.nixos)
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs imp; };
            users.alice = import registry.home.alice;
          };
        }
      ];
    };
}
