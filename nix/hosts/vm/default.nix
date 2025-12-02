# Run with: nix run .#apps.x86_64-linux.vm
{
  imp,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/virtualisation/qemu-vm.nix")
    (imp.configTree ./config)
  ];

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
        source = "$HOME/flakes/ix";
        target = "/mnt/config";
      };
    };
  };

  environment.etc."motd".text = ''

    ╔═══════════════════════════════════════════════════════════╗
    ║  IX NixOS Test VM                                         ║
    ║                                                           ║
    ║  User: alice (password: test)                             ║
    ║  Root password: test                                      ║
    ║  SSH: ssh -p 2222 alice@localhost                         ║
    ║  Config mounted at: /mnt/config                           ║
    ║                                                           ║
    ║  Rebuild: sudo nixos-rebuild test --flake /mnt/config     ║
    ╚═══════════════════════════════════════════════════════════╝

  '';

  system.stateVersion = "24.05";
}
