{
  lib,
  buildFHSEnv,
  stdenv,
  fetchurl,
  zstd,
  withWebkit ? true,
}:

let
  fagram-raw = stdenv.mkDerivation (finalAttrs: {
    pname = "fagram-raw";
    version = "2.5.8";

    src = fetchurl {
      url = "https://github.com/fagramdesktop/nix/releases/download/v${finalAttrs.version}/fagram-desktop-v${finalAttrs.version}-x86_64-linux.tar.zst";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };

    nativeBuildInputs = [ zstd ];

    sourceRoot = ".";

    # Binary is built natively from source in our GitHub Actions CI; keep pristine in FHS wrapper.
    dontPatchELF = true;
    dontStrip = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      if [ -d usr ]; then
        cp -r usr/* $out/
      else
        cp -r * $out/
      fi
      chmod +x $out/bin/*

      runHook postInstall
    '';
  });
in
buildFHSEnv {
  name = "fagram";
  inherit (fagram-raw) version;

  targetPkgs = pkgs: with pkgs; [
    fagram-raw
    alsa-lib
    cairo
    dbus
    fontconfig
    freetype
    gdk-pixbuf
    glib
    glib-networking
    glibc
    gtk3
    libGL
    libdrm
    libpulseaudio
    libva
    libvdpau
    libxkbcommon
    mesa
    pango
    pipewire
    wayland
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXrandr
    xorg.libXtst
    xorg.libxcb
    zlib
  ] ++ lib.optionals withWebkit [ pkgs.webkitgtk_4_1 ];

  profile = ''
    export XDG_DATA_DIRS="/usr/share:$XDG_DATA_DIRS"
    export GIO_EXTRA_MODULES="/usr/lib/gio/modules"
  '';

  runScript = "${fagram-raw}/bin/fagram";

  extraInstallCommands = ''
    mkdir -p $out/share
    if [ -d "${fagram-raw}/share" ]; then
      cp -r ${fagram-raw}/share/* $out/share/
      chmod -R +w $out/share
      if [ -f "$out/share/dbus-1/services/org.fagram.service" ]; then
        substituteInPlace "$out/share/dbus-1/services/org.fagram.service" \
          --replace-fail "/usr/bin/fagram" "$out/bin/fagram"
      fi
      if [ -f "$out/share/applications/org.fagram.desktop" ]; then
        substituteInPlace "$out/share/applications/org.fagram.desktop" \
          --replace-quiet "/usr/bin/fagram" "fagram"
      fi
    fi
    ln -s fagram $out/bin/fagram-bin
  '';

  meta = with lib; {
    description = "FAgram Desktop — official prebuilt package (built from source in CI)";
    homepage = "https://github.com/fagramdesktop/nix";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "fagram";
  };
}
