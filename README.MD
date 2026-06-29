# questpatcher-flake

Nix flake for [QuestPatcher](https://github.com/Lauriethefish/QuestPatcher).

## Usage

### Run directly

```sh
nix run github:Cristiandis/questpatcher-flake
```

### Add to your flake

```nix
inputs.questpatcher-flake = {
    url = "github:Cristiandis/questpatcher-flake";
    inputs.nixpkgs.follows = "nixpkgs";
}

# then in packages or environment.systemPackages:
inputs.questpatcher-flake.packages.${pkgs.stdenv.hostPlatform.system}.questpatcher
```
