# NixOS modules exported by this flake
{ imp, registry, ... }:
{
  base = import registry.modules.nixos.base;
  features = imp registry.modules.nixos.features;
}
