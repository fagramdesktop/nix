# FAgram Desktop — Nix & Flake

Official Nix expressions and Flake repository for [**FAgram Desktop**](https://github.com/fagramdesktop/fadesktop), a custom Telegram Desktop client with feature-rich modifications and Material Design UI.

---

## 🚀 Quick Start

Run FAgram Desktop:

```bash
# Launch default native package:
nix run github:fagramdesktop/nix

# Or launch fast pre-compiled package:
nix run github:fagramdesktop/nix#prebuilt

# Or explicitly select the source build:
nix run github:fagramdesktop/nix#source
```

Install to your user profile:

```bash
# Default native package:
nix profile install github:fagramdesktop/nix

# Or fast prebuilt package:
nix profile install github:fagramdesktop/nix#prebuilt
```

---

## 📦 Available Packages

| Target | Description | Recommended For |
| :--- | :--- | :--- |
| **`#source` / `#default`** | Full native package compiled from source with CMake & Ninja | Pure NixOS / Nix integration, native Wayland & Qt6 theming |
| **`#prebuilt`** | Pre-compiled package built natively by our GitHub Actions CI pipeline | Fast installation without local compilation |

---

## ❄️ NixOS & Home Manager Configuration

### 1. Add Flake Input

In your system or home-manager `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    fagram.url = "github:fagramdesktop/nix";
  };

  outputs = { self, nixpkgs, fagram, ... }: {
    # NixOS configuration
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          environment.systemPackages = [
            fagram.packages.${pkgs.system}.default

            # Or pre-compiled binary:
            # fagram.packages.${pkgs.system}.prebuilt
          ];
        })
      ];
    };
  };
}
```

### 2. Using the Overlay

You can also use the exported overlay:

```nix
nixpkgs.overlays = [
  fagram.overlays.default
];

environment.systemPackages = [
  pkgs.fagram           # Default package
  # pkgs.fagram-prebuilt # Prebuilt package
  # pkgs.fagram-source   # Source build
];
```

---

## 🛠️ Building Locally

To build from this repository locally:

```bash
git clone https://github.com/fagramdesktop/nix.git
cd nix

# Build prebuilt binary:
nix build .#prebuilt
./result/bin/fagram

# Or build from source:
nix build .#source
./result/bin/fagram
```

---

## 🔄 Automatic Updates

When a new version of [FAgram Desktop](https://github.com/fagramdesktop/fadesktop) is released, this repository is automatically updated with both the new prebuilt binary tarball hash and the source revision via GitHub Actions.

## 📄 License

This repository and FAgram Desktop are licensed under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html).
