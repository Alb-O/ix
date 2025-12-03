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
      extraSpecialArgs = { inherit inputs; };
      modules = [
        (imp registry.home.alice)
        (imp registry.modules.home)
      ];
    };
}
