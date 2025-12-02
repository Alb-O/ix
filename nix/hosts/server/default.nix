{ imp, ... }:
{
  imports = [ (imp.configTree ./config) ];

  system.stateVersion = "24.05";
}
