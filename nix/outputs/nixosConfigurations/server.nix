{
  inputs,
  imp,
  lib,
  ...
}:
lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit inputs; };
  modules = [
    ((imp.withLib lib).filterNot (lib.hasInfix "/config/") ../../hosts/server)
    (imp ../../modules/nixos)
    ((imp.withLib lib).filter (lib.hasInfix "/server/") ../../modules/profiles)
  ];
}
