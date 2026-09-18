# FAgram Desktop — Nix & Flake

Official Nix expressions and Flake repository for [**FAgram Desktop**](https://github.com/fagramdesktop/fadesktop), a custom Telegram Desktop client with feature-rich modifications and Material Design UI.

---

## 🚀 Quick Start

Run FAgram Desktop directly without installing:

```bash
nix run github:fagramdesktop/nix
```

Install into your user profile:

```bash
nix profile install github:fagramdesktop/nix
```

---

## ❄️ NixOS & Home Manager Configuration

### 1. Add Flake Input

In your system or home-manager `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    fagram.url = "github:fagramdesktop/nix";
    # Ensure nixpkgs inputs match if desired:
    # fagram.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, fagram, ... }: {
    # NixOS configuration
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # or "aarch64-linux"
      modules = [
        ({ pkgs, ... }: {
          environment.systemPackages = [
            fagram.packages.${pkgs.system}.default
          ];
        })
      ];
    };
  };
}
```

### 2. Using the Overlay

You can also use the exported overlay to expose `pkgs.fagram-desktop`:

```nix
nixpkgs.overlays = [
  fagram.overlays.default
];

environment.systemPackages = [
  pkgs.fagram-desktop
];
```

---

## 🛠️ Building Locally

To build from this repository locally:

```bash
git clone https://github.com/fagramdesktop/nix.git
cd nix
nix build .#fagram-desktop
./result/bin/fagram
```

---

## 🔄 Automatic Updates

When a new version of [FAgram Desktop](https://github.com/fagramdesktop/fadesktop) is released, this repository is automatically updated with the new release version, Git commit revision, and source hash via GitHub Actions.

## 📄 License

This repository and FAgram Desktop are licensed under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html).
