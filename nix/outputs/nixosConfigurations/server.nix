{
  inputs,
  imp,
  lib,
  ...
}:
lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit inputs imp; };
  modules = [
    (imp.filterNot (lib.hasInfix "/config/") ../../hosts/server)
    (imp ../../modules/nixos)
    (imp.filter (lib.hasInfix "/server/") ../../modules/profiles)
  ];
}
