{
  description = "Svelte Effect Nix Template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, treefmt-nix, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      imports = [
        treefmt-nix.flakeModule
        ./app/app.nix
      ];

      perSystem = { config, self', inputs', pkgs, lib, system, ... }:
        let
          pnpm = pkgs.pnpm_10;
          nodejs = pkgs.nodejs-slim_24;
        in
        {
          _module.args = {
            buildPnpmPackage = import ./nix/buildPnpmPackage.nix {
              inherit pkgs pnpm nodejs;
            };
          };

          devShells.default = pkgs.mkShell {
            name = "app-devshell";
            buildInputs = [ pnpm nodejs ] ++ (with pkgs; [
              nodePackages_latest.nodejs
              nodePackages_latest.graphqurl
              nodePackages_latest.svelte-language-server
              nodePackages_latest."@tailwindcss/language-server"
              nodePackages_latest.typescript-language-server
              nodePackages_latest.vscode-langservers-extracted
              config.treefmt.build.wrapper
            ]);
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
