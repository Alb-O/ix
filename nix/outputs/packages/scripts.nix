# Nested packages example
# This demonstrates how imp.treeWith creates nested attrs:
#   outputs/packages/scripts.nix -> packages.scripts.{ ... }
{ pkgs, ... }:
{
  backup = pkgs.writeShellScriptBin "ix-backup" ''
    echo "Backing up configuration..."
    ${pkgs.rsync}/bin/rsync -av --exclude='.git' . ~/backups/ix-$(date +%Y%m%d)/
  '';

  clean = pkgs.writeShellScriptBin "ix-clean" ''
    echo "Cleaning old generations..."
    sudo nix-collect-garbage -d
    nix-collect-garbage -d
  '';
}
