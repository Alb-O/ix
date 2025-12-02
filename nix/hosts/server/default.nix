{ inputs, lib, ... }:
let
  imp = inputs.imp.withLib lib;
in
{
  imports = [ (imp.configTree ./config) ];

  system.stateVersion = "24.05";
}
