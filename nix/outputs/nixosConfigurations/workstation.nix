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
      modules = imp.imports [
        registry.hosts.workstation
        registry.modules.nixos.base
        registry.modules.nixos.features.desktop
        registry.modules.nixos.features.gaming
        registry.modules.nixos.features.hardening
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
