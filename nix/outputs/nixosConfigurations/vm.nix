# VM NixOS configuration - run with: nix run .#vm
{
  __inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  __functor =
    _:
    {
      lib,
      inputs,
      imp,
      registry,
      ...
    }:
    lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs imp registry; };
      modules = [
        (imp.filterNot (lib.hasInfix "/config/") registry.hosts.vm)
        (import registry.modules.nixos.base)
        (import registry.modules.nixos.features.desktop)
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs imp registry; };
            users.alice = import registry.users.alice;
          };
        }
      ];
    };
}
