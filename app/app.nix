_: {
  perSystem =
    {
      self',
      pkgs,
      lib,
      gitShortRev,
      lastModified,
      lastModifiedDate,
      buildPnpmPackage,
      ...
    }:
    let
      PUBLIC_GIT_REV = self'.shortRev or (self'.dirtyShortRev or "dirty");
      PUBLIC_LAST_MODIFIED_DATE = self'.lastModifiedDate or "1970-01-01T00:00:00Z";
      PUBLIC_LAST_MODIFIED_EPOCH =
        if self' ? lastModified then builtins.toString self'.lastModified else "0";
    in
    {
      packages = {
        app = buildPnpmPackage rec {
          packageJsonPath = ./package.json;
          extraSrcs = [
            ../app
          ];
          hash = "sha256-p2/UqetErG5AHlUI2+GFakv4Zbce4MgluVEVpj2F8cI=";
          pnpmWorkspaces = [ "app" ];
          buildPhase = ''
            runHook preBuild
            export PUBLIC_GIT_REV="${PUBLIC_GIT_REV}"
            export PUBLIC_LAST_MODIFIED_DATE="${PUBLIC_LAST_MODIFIED_DATE}"
            export PUBLIC_LAST_MODIFIED_EPOCH="${PUBLIC_LAST_MODIFIED_EPOCH}"
            pnpm --filter=app prepare
            pnpm --filter=app build
            runHook postBuild
          '';
          checkPhase = ''
            pnpm --filter=app check
          '';
          doCheck = true;
          installPhase = ''
            mkdir -p $out
            cp -r ./app/build/* $out
          '';
          doDist = false;
        };
      };
      apps = {
        app-dev = {
          type = "app";
          program = pkgs.writeShellApplication {
            name = "app-dev";
            text = ''
              cd "$(git rev-parse --show-toplevel)/app"
              export PUBLIC_GIT_REV="${PUBLIC_GIT_REV}"
              export PUBLIC_LAST_MODIFIED_DATE="${PUBLIC_LAST_MODIFIED_DATE}"
              export PUBLIC_LAST_MODIFIED_EPOCH="${PUBLIC_LAST_MODIFIED_EPOCH}"
              pnpm install
              pnpm run dev --host
            '';
          };
        };
        app-preview = {
          type = "app";
          program = pkgs.writeShellApplication {
            name = "app-preview";
            runtimeInputs = [ pkgs.miniserve ];
            text = ''
              miniserve --spa --index index.html --port 8080 ${self'.packages.app}
            '';
          };
        };
        app-check-watch = {
          type = "app";
          program = pkgs.writeShellApplication {
            name = "app-check-watch";
            text = ''
              cd "$(git rev-parse --show-toplevel)/app"
              export PUBLIC_GIT_REV="${PUBLIC_GIT_REV}"
              export PUBLIC_LAST_MODIFIED_DATE="${PUBLIC_LAST_MODIFIED_DATE}"
              export PUBLIC_LAST_MODIFIED_EPOCH="${PUBLIC_LAST_MODIFIED_EPOCH}"
              pnpm run check --watch --threshold error
            '';
          };
        };
      };
    };
}
