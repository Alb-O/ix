{ imp, ... }:
{
  imports = [
    ./hardware.nix
    (imp.configTree ./config)
  ];

  system.stateVersion = "24.05";
}
