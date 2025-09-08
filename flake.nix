{
  description = "Svelte Effect Nix Template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, treefmt-nix, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      imports = [
        treefmt-nix.flakeModule
      ];

      perSystem = { config, self', inputs', pkgs, lib, system, ... }: {
        packages =
          let
            packageJSON = lib.importJSON ./package.json;
            buildPnpmPackage = import ./nix/buildPnpmPackage.nix {
              inherit pkgs lib;
            };
          in
          {
            app = buildPnpmPackage {
              hash = "sha256-LtkpP1e597k4r3cRjHPI8Zh/clUfAh10UZf3/WZJYeg=";
              extraSrcs = [
                ./.
              ];
              packageJsonPath = ./package.json;
              buildPhase = ''
                runHook preBuild
                pnpm --filter=app build
                runHook postBuild
              '';
              installPhase = ''
                mkdir -p $out
                cp -r ./build/* $out
              '';
              doCheck = true;
              checkPhase = ''
                pnpm run test
              '';
              doDist = false;
            };
            default = self'.packages.app;
          };

        apps = {
          dev = {
            type = "app";
            program = pkgs.writeShellApplication {
              name = "app-dev-server";
              runtimeInputs = [ pkgs.nodejs ];
              text = ''
                npm install
                npm run dev
              '';
            };
          };
          preview = {
            type = "app";
            program = pkgs.writeShellApplication {
              name = "preview-app";
              runtimeInputs = [ pkgs.miniserve ];
              text = ''
                miniserve --spa --index index.html --port 8080 ${self'.packages.app}
              '';
            };
          };
          default = self'.apps.preview;
        };

        devShells.default = pkgs.mkShell {
          name = "app-devshell";
          buildInputs = with pkgs; [
            nodejs
            nodePackages_latest.nodejs
            nodePackages_latest.graphqurl
            nodePackages_latest.svelte-language-server
            nodePackages_latest."@tailwindcss/language-server"
            nodePackages_latest.typescript-language-server
            nodePackages_latest.vscode-langservers-extracted
            pnpm
            config.treefmt.build.wrapper
          ];
        };

        treefmt = {
          projectRootFile = "flake.nix";
          programs = {
            prettier = {
              enable = true;
              package = pkgs.nodePackages.prettier;
              includes = [
                "*.ts"
                "*.js"
                "*.json"
                "*.md"
                "*.svelte"
                "*.html"
                "*.css"
              ];
            };
            nixpkgs-fmt = {
              enable = true;
              includes = [ "*.nix" ];
            };
          };
        };
      };

      flake.templates.default = {
        path = ./.;
        description = "Reproducible Svelte app with Effect integration";
      };
    };
}
