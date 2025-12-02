# Per-system apps
{ self, pkgs, ... }:
{
  vm = {
    type = "app";
    meta.description = "Run the IX test VM";
    program = toString (
      pkgs.writeShellScript "run-vm" ''
        echo "Building and running IX test VM..."
        echo "Login: alice / test (or root / test)"
        echo "SSH: ssh -p 2222 alice@localhost"
        echo ""
        exec ${self.nixosConfigurations.vm.config.system.build.vm}/bin/run-ix-vm-vm
      ''
    );
  };

  rebuild = {
    type = "app";
    meta.description = "Rebuild NixOS configuration";
    program = toString (
      pkgs.writeShellScript "rebuild" ''
        set -e
        host="''${1:-$(hostname)}"
        echo "Rebuilding NixOS configuration for: $host"
        sudo nixos-rebuild switch --flake "${self}#$host"
      ''
    );
  };

  update = {
    type = "app";
    meta.description = "Update flake inputs";
    program = toString (
      pkgs.writeShellScript "update" ''
        set -e
        echo "Updating flake inputs..."
        nix flake update
        echo "Done. Run 'nix run .#rebuild' to apply changes."
      ''
    );
  };

  info = {
    type = "app";
    meta.description = "Show flake configuration info";
    program = toString (
      pkgs.writeShellScript "info" ''
        echo "IX Flake Configuration"
        echo "======================"
        echo ""
        echo "NixOS Configurations:"
        nix flake show --json 2>/dev/null | ${pkgs.jq}/bin/jq -r '.nixosConfigurations | keys[]' 2>/dev/null || echo "  (run 'nix flake show' for details)"
        echo ""
        echo "Home Configurations:"
        nix flake show --json 2>/dev/null | ${pkgs.jq}/bin/jq -r '.homeConfigurations | keys[]' 2>/dev/null || echo "  (run 'nix flake show' for details)"
      ''
    );
  };
}
