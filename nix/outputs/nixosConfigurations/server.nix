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
    # Host-specific config
    (imp.filterNot (lib.hasInfix "/config/") registry.hosts.server)

    # Base NixOS settings
    (import registry.modules.nixos.base)

    # Server features
    (import registry.modules.nixos.features.hardening)
    (import registry.modules.nixos.features.webserver)
    (import registry.modules.nixos.features.database)
  ];
}
