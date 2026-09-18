# FAgram Desktop — Nix & Flake

Official Nix expressions and Flake repository for [**FAgram Desktop**](https://github.com/fagramdesktop/fadesktop), a custom Telegram Desktop client with feature-rich modifications and Material Design UI.

---

## 🚀 Quick Start

Run FAgram Desktop immediately without compiling (~5 seconds):

```bash
# Instant launch (prebuilt binary is the default):
nix run github:fagramdesktop/nix

# Explicitly select the prebuilt binary package:
nix run github:fagramdesktop/nix#prebuilt

# Or compile and run from source:
nix run github:fagramdesktop/nix#source
```

Install to your user profile:

```bash
# Fast prebuilt binary:
nix profile install github:fagramdesktop/nix#prebuilt

# Or build from source:
nix profile install github:fagramdesktop/nix#source
```

---

## 📦 Available Packages

| Target | Description | Recommended For |
| :--- | :--- | :--- |
| **`#prebuilt`** (default on x86_64) | Instant prebuilt binary using `autoPatchelfHook` | Everyday use, fast setup, no compile time |
| **`#source`** | Full source build compiled with CMake & Ninja | Custom patches, development, aarch64 |

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
            # Use instant prebuilt binary:
            fagram.packages.${pkgs.system}.prebuilt

            # Or compile from source:
            # fagram.packages.${pkgs.system}.source
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
  pkgs.fagram-prebuilt  # Fast binary
  # pkgs.fagram-source  # Source build
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
