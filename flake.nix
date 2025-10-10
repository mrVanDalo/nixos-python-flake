{
  description = "nixos-unstable for python packages. It's will automatically be updated, so I don't have to do this in my nixos configuration";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-2505.url = "github:NixOS/nixpkgs/nixos-25.05";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      flake-parts,
      self,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ./nix/formatter.nix ];
      systems = [ "x86_64-linux" ];
      perSystem =
        { pkgs, self', ... }:
        with pkgs;
        {
          packages = {
            inherit (pkgs) matrix-synapse;
            yubioath-flutter = inputs.nixpkgs.legacyPackages.${system}.pkgs.yubioath-flutter;
          };
          checks = self'.packages;
        };
    };
}
