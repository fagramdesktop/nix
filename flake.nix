{
  description = "FAgram Desktop — Nix packaging & Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSystem = nixpkgs.lib.genAttrs systems;
    in {
      packages = forEachSystem (system:
        let
          pkgs = import nixpkgs { inherit system; };

          fagram-desktop = pkgs.kdePackages.callPackage ./pkgs/default.nix {
            tg_owt = pkgs.telegram-desktop.tg_owt;
          };
        in {
          inherit fagram-desktop;
          source = fagram-desktop;
          default = fagram-desktop;
        }
      );

      apps = forEachSystem (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/fagram";
        };
        fagram-desktop = {
          type = "app";
          program = "${self.packages.${system}.fagram-desktop}/bin/fagram";
        };
        source = {
          type = "app";
          program = "${self.packages.${system}.source}/bin/fagram";
        };
      });

      overlays.default = final: prev: {
        fagram = self.packages.${prev.system}.default;
        fagram-desktop = self.packages.${prev.system}.default;
        fagram-source = self.packages.${prev.system}.default;
      };
    };
}
