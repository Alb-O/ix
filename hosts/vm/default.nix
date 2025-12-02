# VM configuration for testing with QEMU
# Run with: nix run .#vm
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
    (modulesPath + "/virtualisation/qemu-vm.nix")
    (imp.configTree ./config)
  ];

  # VM-specific settings (complex nested structure, kept here)
  virtualisation = {
    memorySize = 4096; # MB
    cores = 2;
    graphics = true;
    qemu.options = [
      "-vga virtio"
      "-display gtk,zoom-to-fit=on"
    ];
    # Forward SSH port
    forwardPorts = [
      {
        from = "host";
        host.port = 2222;
        guest.port = 22;
      }
    ];
    # Shared folder with host
    sharedDirectories = {
      config = {
        source = "$HOME/flakes/ix";
        target = "/mnt/config";
      };
    };
  };

  # Quick info on login
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
