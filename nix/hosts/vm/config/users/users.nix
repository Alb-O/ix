# Password: test
{ ... }:
{
  alice = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "test";
  };
  root.initialPassword = "test";
}
