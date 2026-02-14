{
  description = "Protocol Zero: The Elixir Backend Base";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # FIX: We explicitely allow unfree packages (required for SurrealDB)
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Core Runtime
            elixir
            erlang

            # Dev Tools
            elixir-ls
            inotify-tools
            
            # The "Sovereign" Data Layer
            protobuf
            surrealdb
            just       # Now allowed!
            
            # Utilities
			just
            jq
            ripgrep
          ];

          shellHook = ''
            echo "⚡ Protocol Zero: Backend Environment Loaded ⚡"
            echo "Elixir: $(elixir -e "IO.puts System.version()")"
            echo "Protoc: $(protoc --version)"
            
            # Auto-create local DB directory if missing
            mkdir -p priv/data
            
            # Optional: Alias to start DB easily
            alias db="surreal start --user root --pass root file:priv/data/mydatabase.db"
          '';
        };
      }
    );
}
