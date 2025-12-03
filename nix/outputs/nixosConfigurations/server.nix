{
  inputs,
  lib,
  imp,
  registry,
  ...
}:
lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit inputs imp; };
  modules = [
    (imp.filterNot (lib.hasInfix "/config/") registry.hosts.server)
    (imp registry.modules.nixos)
    (imp.filter (lib.hasInfix "/server/") registry.modules.profiles)
  ];
}
