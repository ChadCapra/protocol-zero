{
  description = "Protocol Zero: The Elixir Backend Base (PostgreSQL)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            elixir
            erlang
            elixir-ls
            inotify-tools
            
            # The "Sovereign" Data Layer
            protobuf
            postgresql_15
            just
            jq
            ripgrep
          ];

          shellHook = ''
            echo "⚡ Protocol Zero: Backend Environment Loaded ⚡"
            export PGDATA="$PWD/priv/data/pg"
          '';
        };
      }
    );
}
