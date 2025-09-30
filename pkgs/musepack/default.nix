{
  stdenv,
  lib,
  fetchsvn,
  cmake,
  ninja,
  flac,
  cuetools,
  autoreconfHook,
  libcue,
  callPackage,
}:
let
  libreplaygain = callPackage ./libreplaygain.nix { };
  libcuefile = callPackage ./libcuefile.nix { };
  libmpcdec = callPackage ./libmpcdec.nix { };
in
stdenv.mkDerivation rec {
  pname = "musepack";
  version = "495";

  src = fetchsvn {
    url = "http://svn.musepack.net/libmpc/trunk";
    rev = version;
    sha256 = "sha256-b6hwqGYGuhwpSkkzqCRgsUZ6/QS6QBh+KDFDPfBLRns=";
  };

  # sourceRoot = "${pname}_src_r${version}";
  # sourceRoot = ".";

  hardeningDisable = [ "all" ];

  nativeBuildInputs = [
    autoreconfHook
    cmake
    ninja
  ];

  buildInputs = [
    cuetools
    libcue
    libcuefile
    libreplaygain
    libmpcdec
    flac
  ];

  patches = [
    ./mpcchap.patch

    ./musepack-tools-495-fixup-link-depends.patch
    ./musepack-tools-495-incompatible-pointers.patch
    ./musepack-tools-495-respect-cflags.patch
    ./05_visibility.patch
  ];

  postPatch = ''
    # echo "add_compile_options(-Wno-everything)" >> CMakeLists.txt
    # substituteInPlace CMakeLists.txt \
    #   --replace-fail "project(mpcdec)" \
    #             "project(mpcdec)\nadd_compile_options(-Wno-error=restrict)"
    # substituteInPlace CMakeLists.txt \
    #   --replace-fail "project(mpcchap)" \
    #             "project(mpcchap)\nadd_compile_options(-Wno-error=restrict)"
  '';

  configureFlags = [
    "--disable-maintainer-mode"
    "--enable-mpcchap"
  ];

  # buildPhase = ''
  #   mkdir -p build
  #   cd build
  #     cmake \
  #       -DCMAKE_C_FLAGS:STRING="$SLKCFLAGS" \
  #       -DCMAKE_INSTALL_PREFIX=/usr \
  #       -DLIB_SUFFIX=$LIBDIRSUFFIX \
  #       -DCMAKE_BUILD_TYPE=Release ..
  #     make -j1
  #     make install DESTDIR=$PKG
  #   cd ..
  # '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    # "-DBUILD_MPCCHAP=OFF"
    "-DREPLAY_GAIN_INCLUDE_DIR=${libreplaygain}/include/replaygain"
    "-DREPLAY_GAIN_LIBRARY=${libreplaygain}/lib/libreplaygain.so"
    "-DCUEFILE_INCLUDE_DIR=${libcuefile}/include"
    "-DCUEFILE_LIBRARY=${libcuefile}/lib/libcue.so"
  ];

  NIX_CFLAGS_COMPILE_APPEND = "-fvisibility=hidden";

  # outputs = ["out" "lib" "dev"];

  meta = {
    mainProgram = "mpcenc";
    description = "Encoder for the musepack format";
    homepage = "https://musepack.net";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.linux;
  };
}
