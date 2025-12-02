# Workstation host configuration
{
  inputs,
  lib,
  modulesPath,
  ...
}:
let
  imp = inputs.imp.withLib lib;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (imp.configTree ./config)
  ];

  system.stateVersion = "24.05";
}
