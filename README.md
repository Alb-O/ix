# ixample

A reference NixOS/Home Manager configuration demonstrating [imp](https://github.com/imp-nix/imp.lib) patterns.

## Structure

```
nix/
  flake/                    # Flake entry point
    default.nix
    inputs.nix
  outputs/                  # Auto-loaded by imp
    homeConfigurations/
    nixosConfigurations/
    perSystem/
  registry/                 # Named module registry
    hosts/                  # Host-specific configs
      server/
      vm/
      workstation/
    modules/                # Reusable features
      home/features/
      nixos/features/
    users/
      alice/
```

## Patterns

### Registry references

Modules reference each other by name, not path:

```nix
# registry/users/alice/default.nix
{ registry, imp, ... }:
{
  imports = imp.imports [
    registry.modules.home.features.devShell
    registry.modules.home.features.modernUnix
  ];
}
```

imp converts the directory path to an attribute path: `registry/modules/home/features/devShell/` becomes `registry.modules.home.features.devShell`.

### Config trees

Split configuration across files whose paths mirror option paths:

```nix
# registry/hosts/workstation/default.nix
{ imp, ... }:
{
  imports = [ (imp.configTree ./config) ];
}
```

The file `config/networking/hostName.nix` sets `networking.hostName`. The file `config/services/openssh.nix` sets `services.openssh.*`.

### Merged config trees

Compose features by merging multiple config trees:

```nix
# registry/modules/home/features/devShell/default.nix
{ imp, registry, ... }:
{
  imports = [
    (imp.mergeConfigTrees { strategy = "merge"; } [
      registry.modules.home.features.shell
      registry.modules.home.features.devTools
      ./.
    ])
  ];
}
```

The `merge` strategy uses the NixOS module system to combine definitions: lists concatenate, attrsets merge recursively.

### Auto-generated flake.nix

Inputs declared inline with `__inputs` are collected and merged into `flake.nix`:

```nix
# outputs/perSystem/formatter.nix
__inputs = {
  treefmt-nix.url = "github:numtide/treefmt-nix";
};
```

Regenerate with `nix run .#imp-flake`.

## Host configuration

Each host has a `default.nix`, `hardware.nix`, and a `config/` tree:

```nix
# registry/hosts/workstation/default.nix
{ imp, inputs, registry, modulesPath, ... }:
{
  imports = [
    ./hardware.nix
    (modulesPath + "/installer/scan/not-detected.nix")
    (imp.configTree ./config)
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs imp registry; };
    users.alice = import registry.users.alice;
  };

  system.stateVersion = "24.05";
}
```

## Feature modules

Each feature is a config tree that can be imported independently:

```nix
# registry/modules/home/features/shell/default.nix
{ imp, ... }:
{
  imports = [ (imp.configTree ./.) ];
}
```

With config files at `programs/zsh.nix`, `programs/starship.nix`, etc.

## Commands

```bash
nix build .#nixosConfigurations.workstation.config.system.build.toplevel
nix develop
nix fmt
nix run .#imp-flake
```

## Documentation

- [imp docs](https://imp-nix.github.io/imp.lib/)
- [Registry](https://imp-nix.github.io/imp.lib/concepts/registry.html)
- [Config trees](https://imp-nix.github.io/imp.lib/guides/config-trees.html)
