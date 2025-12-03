# Run with: nix run .#vm
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
      specialArgs = { inherit inputs imp registry; };
      modules = [
        # Host-specific config
        (imp.filterNot (lib.hasInfix "/config/") registry.hosts.vm)

        # Base NixOS settings
        (import registry.modules.nixos.base)

        # Home Manager
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
