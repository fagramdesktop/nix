{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  ninja,
  clang,
  python3,
  qtbase,
  qtsvg,
  qtwayland,
  qtshadertools,
  kcoreaddons,
  lz4,
  xxhash,
  ffmpeg_6,
  protobuf,
  openal-soft,
  minizip-ng-compat,
  range-v3,
  tl-expected,
  hunspell,
  gobject-introspection,
  rnnoise,
  microsoft-gsl,
  boost,
  ada,
  tdlib,
  tg_owt,
  pango,
  tlottie,
  ccache,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fagram-desktop-unwrapped";
  version = "2.5.7";

  src = fetchFromGitHub {
    owner = "fagramdesktop";
    repo = "fadesktop";
    rev = "6c554e1b8ce328186766148b59d6991fe2a0e42f";
    fetchSubmodules = true;
    hash = "sha256-jghaNXPtiHlSQSGRkfebcL+dUIlq9Ef9dA5JCpgfyOs=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    python3
    qtshadertools
    clang
    gobject-introspection
    ccache
  ];

  buildInputs = [
    pango
    qtbase
    qtsvg
    lz4
    xxhash
    ffmpeg_6
    openal-soft
    minizip-ng-compat
    range-v3
    tl-expected
    rnnoise
    tg_owt
    microsoft-gsl
    boost
    ada
    (tdlib.override { tde2eOnly = true; })
    protobuf
    qtwayland
    kcoreaddons
    hunspell
    tlottie
  ];

  dontWrapQtApps = true;

  preConfigure = ''
    if [ -d /var/cache/ccache ]; then
      export CCACHE_DIR=/var/cache/ccache
      export CCACHE_SLOPPINESS=pch_defines,time_macros
    elif [ -n "$CCACHE_DIR" ]; then
      export CCACHE_SLOPPINESS=pch_defines,time_macros
    else
      export CCACHE_DISABLE=1
    fi
  '';

  cmakeFlags = [
    (lib.cmakeFeature "TDESKTOP_API_ID" "37535655")
    (lib.cmakeFeature "TDESKTOP_API_HASH" "3c6cd55d00180f7439bc2edf391306cf")
    (lib.cmakeBool "DESKTOP_APP_DISABLE_AUTOUPDATE" true)
    (lib.cmakeBool "DESKTOP_APP_USE_PACKAGED" true)
    (lib.cmakeFeature "CMAKE_C_COMPILER_LAUNCHER" "ccache")
    (lib.cmakeFeature "CMAKE_CXX_COMPILER_LAUNCHER" "ccache")
  ];

  meta = with lib; {
    mainProgram = "fagram";
    description = "FAgram Desktop — unofficial TG desktop client (with some nice feature's)";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    homepage = "https://github.com/fagramdesktop/fadesktop";
  };
})
