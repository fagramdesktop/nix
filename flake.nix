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

          source = pkgs.kdePackages.callPackage ./pkgs/default.nix {
            tg_owt = pkgs.telegram-desktop.tg_owt;
          };

          prebuilt = if system == "x86_64-linux"
            then pkgs.callPackage ./pkgs/binary.nix { }
            else source;
        in {
          inherit source prebuilt;
          # Aliases
          fagram-desktop = source;
          fagram-bin = prebuilt;
          # Default to native source build
          default = source;
        }
      );

      apps = forEachSystem (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/fagram";
        };
        prebuilt = {
          type = "app";
          program = "${self.packages.${system}.prebuilt}/bin/fagram";
        };
        source = {
          type = "app";
          program = "${self.packages.${system}.source}/bin/fagram";
        };
      });

      overlays.default = final: prev: {
        fagram = self.packages.${prev.system}.default;
        fagram-desktop = self.packages.${prev.system}.source;
        fagram-prebuilt = self.packages.${prev.system}.prebuilt;
        fagram-source = self.packages.${prev.system}.source;
        fagram-bin = self.packages.${prev.system}.prebuilt;
      };
    };
}
