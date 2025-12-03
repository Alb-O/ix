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
  modules = imp.imports [
    registry.hosts.server
    registry.modules.nixos.base
    registry.modules.nixos.features.hardening
    registry.modules.nixos.features.webserver
    registry.modules.nixos.features.database
  ];
}
