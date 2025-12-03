# Server NixOS configuration
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
    (imp.filterNot (lib.hasInfix "/config/") registry.hosts.server)
    (import registry.modules.nixos.base)
    (import registry.modules.nixos.features.hardening)
    (import registry.modules.nixos.features.webserver)
    (import registry.modules.nixos.features.database)
  ];
}
