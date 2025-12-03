# Standalone Home Manager configuration for alice@workstation
{
  __inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  __functor =
    _:
    {
      inputs,
      imp,
      nixpkgs,
      registry,
      ...
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = { inherit inputs imp registry; };
      modules = [ (import registry.users.alice) ];
    };
}
