{
  description = "QuestPatcher packaged for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {
          questpatcher = pkgs.callPackage ./pkgs/questpatcher { };
          default = self.packages.${system}.questpatcher;
        };

        apps.default = flake-utils.lib.mkApp {
          drv = self.packages.${system}.questpatcher;
        };
      }
    );
}
