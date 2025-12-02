{ ... }:
{
  alice = {
    isNormalUser = true;
    description = "Alice";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
