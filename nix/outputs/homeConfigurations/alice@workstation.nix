{
  inputs,
  imp,
  nixpkgs,
  home-manager,
  ...
}:
home-manager.lib.homeManagerConfiguration {
  pkgs = nixpkgs.legacyPackages.x86_64-linux;
  extraSpecialArgs = { inherit inputs; };
  modules = [
    (imp ../../home/alice)
    (imp ../../modules/home)
  ];
}
