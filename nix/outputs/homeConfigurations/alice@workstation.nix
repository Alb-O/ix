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
      ...
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = { inherit inputs; };
      modules = [
        (imp ../../home/alice)
        (imp ../../modules/home)
      ];
    };
}
