# Gaming feature
# Steam, gamemode, and graphics support for gaming on NixOS
{ ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  programs.gamemode.enable = true;

  hardware.graphics.enable32Bit = true;
}
