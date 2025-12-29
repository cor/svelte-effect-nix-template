{ pkgs }:
{
  package = pkgs.treefmt;
  projectRootFile = "flake.nix";
  programs = {
    biome = {
      enable = true;
      package = pkgs.biome;
      settings = builtins.fromJSON (builtins.readFile ../biome.json);
      validate = {
        enable = true;
        schema = pkgs.fetchurl {
          url = "https://biomejs.dev/schemas/2.3.9/schema.json";
          hash = "sha256-iGFDTliW7WKae+f8C6Ksic9rul8dU+0veygfLQmI/XE=";
        };
      };
    };
    taplo.enable = true;
    yamlfmt = {
      enable = true;
      package = pkgs.yamlfmt;
    };
    mdformat = {
      enable = true;
      package = pkgs.mdformat;
    };
    shellcheck = {
      enable = true;
      package = pkgs.shellcheck;
    };
    nixfmt-rfc-style = {
      enable = true;
      package = pkgs.nixfmt-rfc-style;
    };
    statix = {
      enable = true;
      package = pkgs.statix;
    };
    deadnix = {
      enable = true;
      package = pkgs.deadnix;
    };
  };
  settings = {
    formatter = {
      biome.includes = [
        "*.ts"
        "*.js"
        "*.css"
        "*.json"
        "*.jsonc"
        "*.tsx"
        "*.jsx"
        "*.graphql"
        "*.html"
        "*.svelte"
        "*.astro"
      ];
      nixfmt-rfc-style = {
        options = [ ];
        includes = [ "*.nix" ];
      };
      statix.options = [ "explain" ];
      mdformat.options = [ "--number" ];
      deadnix.options = [ "--no-lambda-pattern-names" ];
      shellcheck.options = [
        "--shell=bash"
        "--check-sourced"
      ];
      yamlfmt.options = [
        "-formatter"
        "retain_line_breaks=true"
      ];
    };
    global = {
      hidden = true;
      excludes = [
        "_/**"
        "*.ttf"
        "*.png"
        "*.prv"
        "*.bin"
        "*.jpg"
        "*.svg"
        "*.jpeg"
        "*.lock"
        ".git/**"
        "*.woff2"
        "*.lockb"
        ".ignore"
        "LICENSE"
        "LICENSE*"
        "**/*.ico"
        "**/*.zip"
        "**/.npmrc"
        "**/LICENSE"
        ".gitignore"
        "CODEOWNERS"
        "*.template"
        ".gitignore"
        "**/.sqlx/**"
        "**/vendor/**"
        "*.splinecode"
        "**/.gitignore"
        ".gitattributes"
        "**/testdata/**"
        "**/testswap/**"
        "**/generated/**"
        ".github/**/*.sh"
        ".github/**/*.md"
        "**/.gitattributes"
        ".git-blame-ignore-revs"
      ];
    };
  };
}
