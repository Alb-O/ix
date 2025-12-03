# Workstation NixOS configuration
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
        (imp.filterNot (lib.hasInfix "/config/") registry.hosts.workstation)
        (import registry.modules.nixos.base)
        (import registry.modules.nixos.features.desktop)
        (import registry.modules.nixos.features.gaming)
        (import registry.modules.nixos.features.hardening)
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
