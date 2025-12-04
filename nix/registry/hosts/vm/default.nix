# Run with: nix run .#vm
{
  imp,
  inputs,
  registry,
  ...
}:
{
  imports = [
    ./hardware.nix
    (imp.configTree ./config)
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs imp registry; };
    users.alice = import registry.users.alice;
  };

  environment.etc."motd".text = ''

    ╔═══════════════════════════════════════════════════════════╗
    ║  ixample NixOS Test VM                                         ║
    ║                                                           ║
    ║  User: alice (password: changeme)                         ║
    ║  Root password: changeme                                  ║
    ║  SSH: ssh -p 2222 alice@localhost                         ║
    ║  Config mounted at: /mnt/config                           ║
    ║                                                           ║
    ║  Rebuild: sudo nixos-rebuild test --flake /mnt/config     ║
    ╚═══════════════════════════════════════════════════════════╝

  '';

  system.stateVersion = "24.05";
}
