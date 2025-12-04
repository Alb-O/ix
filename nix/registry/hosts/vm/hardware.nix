# VM hardware configuration
# Uses QEMU virtualization module instead of physical hardware
{ modulesPath, lib, ... }:
{
  imports = [ (modulesPath + "/virtualisation/qemu-vm.nix") ];

  virtualisation = {
    memorySize = 4096;
    cores = 2;
    graphics = true;
    qemu.options = [
      "-vga virtio"
      "-display gtk,zoom-to-fit=on"
    ];
    forwardPorts = [
      {
        from = "host";
        host.port = 2222;
        guest.port = 22;
      }
    ];
    sharedDirectories = {
      config = {
        source = "$HOME/flakes/ixample";
        target = "/mnt/config";
      };
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
