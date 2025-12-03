# Home Manager modules exported by this flake
{ imp, registry, ... }:
{
  base = import registry.modules.home.base;
  features = imp registry.modules.home.features;
}
