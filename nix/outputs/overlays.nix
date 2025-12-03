# Overlays exported by this flake
{ self, ... }:
{
  default = final: prev: {
    ix = self.packages.${prev.system} or { };
  };
}
