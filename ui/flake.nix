{
  description = "Protocol Zero: The Svelte Frontend Base";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs_20
            protobuf
            just
          ];

          shellHook = ''
            echo "⚡ Protocol Zero: UI Environment Loaded ⚡"
            echo "Node: $(node -v)"
          '';
        };
      }
    );
}