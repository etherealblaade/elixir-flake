{
  description = "Elixir Phoenix LiveView development environment with Erlang OTP 26, macOS support, direnv integration, and custom-built elixir-ls";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    elixir-ls = {
      url = "github:elixir-lsp/elixir-ls";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, elixir-ls }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ ];
        };
        
        erlangOTP26 = pkgs.erlangR26;
        elixirOTP26 = (pkgs.elixir.override {
          erlang = erlangOTP26;
        });

        darwinPackages = pkgs.lib.optionals pkgs.stdenv.isDarwin [
          pkgs.darwin.apple_sdk.frameworks.CoreFoundation
          pkgs.darwin.apple_sdk.frameworks.CoreServices
          pkgs.libiconv
        ];

        fileWatcher = if pkgs.stdenv.isDarwin then pkgs.fswatch else pkgs.inotify-tools;

        buildElixirLS = pkgs.stdenv.mkDerivation {
          name = "elixir-ls";
          src = elixir-ls;
          buildInputs = [ erlangOTP26 elixirOTP26 pkgs.git pkgs.makeWrapper ];
          buildPhase = ''
            export MIX_ENV=prod
            export HEX_HOME=$PWD/hex
            export MIX_HOME=$PWD/mix
            mix local.hex --force
            mix local.rebar --force
            mix deps.get
            mix compile
            mix elixir_ls.release
          '';
          installPhase = ''
            mkdir -p $out/bin
            cp -r release $out/
            makeWrapper ${erlangOTP26}/bin/erl $out/bin/elixir-ls \
              --add-flags "-noshell -noinput" \
              --add-flags "-s elixir_ls_utils" \
              --add-flags "start_distribution" \
              --set ELIXIR_LS_PATH "$out/release"
          '';
        };

      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            erlangOTP26
            elixirOTP26
            pkgs.nodejs
            pkgs.postgresql
            fileWatcher
            pkgs.git
            pkgs.vim
            pkgs.direnv
            buildElixirLS
          ] ++ darwinPackages;

          shellHook = ''
            print_info() {
              printf "\033[0;34m%s\033[0m %s\n" "$1:" "$2"
            }

            echo ""
            echo "🎉 Welcome to your Elixir Phoenix LiveView development environment! 🎉"
            echo ""
            print_info "Erlang version" "$(erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell)"
            print_info "Elixir version" "$(elixir --version | head -n 1)"
            print_info "Node.js version" "$(node --version)"
            print_info "PostgreSQL version" "$(psql --version | cut -d " " -f 3)"
            print_info "Elixir LS" "Custom built ($(elixir-ls --version 2>/dev/null || echo 'version not available'))"
            echo ""
            
            export MIX_HOME=$HOME/.mix
            export HEX_HOME=$HOME/.hex
            export PATH=$MIX_HOME/bin:$HEX_HOME/bin:$PATH

            if [ ! -f .mix/cached_installs ]; then
              echo "Installing/updating hex, rebar, and Phoenix..."
              mix local.hex --force
              mix local.rebar --force
              mix archive.install hex phx_new --force
              mkdir -p .mix && touch .mix/cached_installs
            fi

            if [ "$(uname)" == "Darwin" ]; then
              export CFLAGS="-I${pkgs.darwin.apple_sdk.frameworks.CoreFoundation}/Library/Frameworks/CoreFoundation.framework/Headers"
              export LDFLAGS="-L${pkgs.darwin.apple_sdk.frameworks.CoreFoundation}/Library/Frameworks -framework CoreFoundation"
            fi

            echo "🚀 Your development environment is ready! Happy coding! 🚀"
            echo "Elixir LS is available in your PATH. Your editor (e.g., Helix) should be able to find it."
            echo ""
          '';
        };
      }
    );
}
