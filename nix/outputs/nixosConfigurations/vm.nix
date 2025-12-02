# Run with: nix run .#vm
{
  inputs,
  imp,
  lib,
  home-manager,
  ...
}:
lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit inputs imp; };
  modules = [
    (imp.filterNot (lib.hasInfix "/config/") ../../hosts/vm)
    (imp ../../modules/nixos)
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs imp; };
        users.alice = import ../../home/alice;
      };
    }
  ];
}
