# Ixample

Demonstration NixOS configurations using [imp](https://github.com/imp-nix/imp.lib).

This repository showcases patterns for organizing NixOS and Home Manager configurations with imp's directory-based imports, module registries, and automatic input collection.

## Directory Structure

```
nix/
├── flake/                  # Flake configuration
│   ├── default.nix         # flake-parts entry point
│   └── inputs.nix          # Core flake inputs
├── outputs/                # Flake outputs (auto-loaded by imp)
│   ├── homeConfigurations/ # Home Manager configurations
│   ├── nixosConfigurations/# NixOS system configurations
│   ├── perSystem/          # Per-system outputs (packages, devShells, etc.)
│   ├── homeModules.nix     # Exported home-manager modules
│   ├── nixosModules.nix    # Exported NixOS modules
│   └── systems.nix         # Supported systems list
└── registry/               # Named module registry
    ├── hosts/              # Host-specific configurations
    │   ├── server/
    │   ├── vm/
    │   └── workstation/
    ├── modules/            # Reusable feature modules
    │   ├── home/           # Home Manager modules
    │   │   └── features/   # Composable features (shell, devTools, etc.)
    │   └── nixos/          # NixOS modules
    │       └── features/   # System features (desktop, gaming, etc.)
    └── users/              # User configurations
        └── alice/
```

## Key Patterns

### 1. Registry-Based Module References

Instead of relative paths, reference modules by name:

```nix
# In registry/users/alice/default.nix
{ registry, imp, ... }:
{
  imports = imp.imports [
    registry.modules.home.features.devShell
    registry.modules.home.features.modernUnix
  ];
}
```

The registry maps directory structure to attribute paths:

- `registry/modules/home/features/devShell/` → `registry.modules.home.features.devShell`

### 2. Config Trees

Split NixOS/Home Manager configuration across multiple files:

```nix
# In registry/hosts/workstation/default.nix
{ imp, ... }:
{
  imports = [
    (imp.configTree ./config)  # Loads all .nix files from ./config
  ];
}
```

Directory structure becomes option paths:

- `config/networking/hostName.nix` → sets `networking.hostName`
- `config/services/openssh.nix` → sets `services.openssh.*`

### 3. Merged Config Trees

Compose features by merging multiple config trees:

```nix
# In registry/modules/home/features/devShell/default.nix
{ imp, registry, ... }:
{
  imports = [
    (imp.mergeConfigTrees { strategy = "merge"; } [
      registry.modules.home.features.shell
      registry.modules.home.features.devTools
      ./.  # Local overrides
    ])
  ];
}
```

The `merge` strategy concatenates list options (like shell aliases) rather than replacing them.

### 4. Auto-Generated flake.nix

The `flake.nix` is generated from `__inputs` declarations scattered throughout the codebase:

```nix
# In outputs/perSystem/formatter.nix
__inputs = {
  treefmt-nix.url = "github:numtide/treefmt-nix";
};
```

Regenerate with:

```bash
nix run .#imp-flake
```

### 5. Directory-Based Outputs

imp auto-loads outputs from the `outputs/` directory:

| File/Directory                      | Becomes                       |
| ----------------------------------- | ----------------------------- |
| `outputs/systems.nix`               | `systems`                     |
| `outputs/perSystem/*.nix`           | `perSystem.*`                 |
| `outputs/nixosModules.nix`          | `flake.nixosModules`          |
| `outputs/nixosConfigurations/*.nix` | `flake.nixosConfigurations.*` |

## Host Configuration Example

Each host has:

- `default.nix` - Main configuration
- `hardware.nix` - Hardware-specific settings
- `config/` - Option settings organized by path

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

## Feature Module Example

Features are self-contained modules that can be composed:

```nix
# registry/modules/home/features/shell/default.nix
{ imp, ... }:
{
  imports = [ (imp.configTree ./.) ];
}
```

With config files:

- `programs/zsh.nix` - Zsh configuration
- `programs/starship.nix` - Prompt customization
- `programs/fzf.nix` - Fuzzy finder

## Getting Started

1. Clone this repository as a template
2. Modify `registry/hosts/` for your machines
3. Customize `registry/users/` for your users
4. Add features to `registry/modules/`
5. Run `nix run .#imp-flake` to regenerate `flake.nix`

## Commands

```bash
# Build a NixOS configuration
nix build .#nixosConfigurations.workstation.config.system.build.toplevel

# Enter development shell
nix develop

# Format code
nix fmt

# Regenerate flake.nix from __inputs
nix run .#imp-flake
```

## Learn More

- [imp documentation](https://imp-nix.github.io/imp.lib/)
- [Registry pattern guide](https://imp-nix.github.io/imp.lib/concepts/registry.html)
- [Config tree guide](https://imp-nix.github.io/imp.lib/guides/config-trees.html)
