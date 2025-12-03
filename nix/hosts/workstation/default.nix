{
  imp,
  modulesPath,
  ...
}:
{
  imports = [
    ./hardware.nix
    (modulesPath + "/installer/scan/not-detected.nix")
    (imp.configTree ./config)
  ];

  system.stateVersion = "24.05";
}
