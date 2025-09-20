{
  stdenv,
  lib,
  fetchzip,
  cmake,
  cuetools,
  autoreconfHook,
  fetchpatch,
  libcue,
  callPackage,
}: let
  libreplaygain = callPackage ./libreplaygain.nix {};
  libcuefile = callPackage ./libcuefile.nix {};
in
  stdenv.mkDerivation rec {
    pname = "musepack";
    version = "475";

    src = fetchzip {
      url = "https://files.musepack.net/source/musepack_src_r${version}.tar.gz";
      sha256 = "sha256-INs092+1YZDK5mH0o0559EB/WNxVCGuXey8mOim+8gY=";
      # url = "https://dev.gentoo.org/~sam/distfiles/media-sound/musepack-tools/musepack-tools-${version}.tar.xz";
      # sha256 = "sha256-EVrJPJ+OL+KfGv5fYg4fbQORmLfSbFar7Wnpj2wkKEM=";
    };

    # sourceRoot = "${pname}_src_r${version}";
    # sourceRoot = ".";

    nativeBuildInputs = [
      autoreconfHook
      cmake
    ];

    buildInputs = [
      cuetools
      libcue
      libcuefile
      libreplaygain
    ];

    patches = [
      # ./mpcchap.patch

      ./01_am-maintainer-mode.patch
      ./02_link-libm.patch
      ./03_mpcchap.patch
      ./04_link-order.patch
      ./05_visibility.patch
      ./1001_missing_extern_kw.patch
      ./add_subdir-objects.patch
      ./musepack-tools-495-incompatible-pointers.patch

      # ./05_visibility.patch
      # ./add_subdir-objects.patch

      # ./r482.patch
      # ./r479.patch
      # ./r491.patch
      # ./musepack-tools-495-fixup-link-depends.patch
      # ./musepack-tools-495-incompatible-pointers.patch

      # (fetchpatch {
      #   url = "https://raw.githubusercontent.com/Homebrew/formula-patches/743dc747e291fd5b1c6ebedfef2778f1f7cde77d/musepack/r479.patch";
      #   sha256 = "sha256-s7DMyDO7BsD6UFtSNFuPRKmsRScB/kRsSGAdMZ4KaJg=";
      #   stripLen = 0;
      # })
      # (fetchpatch {
      #   url = "https://raw.githubusercontent.com/Homebrew/formula-patches/743dc747e291fd5b1c6ebedfef2778f1f7cde77d/musepack/r482.patch";
      #   sha256 = "sha256-udCNxGiGeWMC0T2uNT0askggFVSA4sKhFU1VyXHPU74=";
      #   stripLen = 0;
      # })
      # (fetchpatch {
      #   url = "https://raw.githubusercontent.com/Homebrew/formula-patches/743dc747e291fd5b1c6ebedfef2778f1f7cde77d/musepack/r491.patch";
      #   sha256 = "sha256-IZzUXGpSSck/6QK1NU5E+TLvg6qk9kUdcKWYoqajJF8=";
      #   stripLen = 0;
      # })
      # (fetchpatch {
      #   url = "https://raw.githubusercontent.com/gentoo/gentoo/f5d4d4995d45baf77c176224b62e424dca037aef/media-sound/musepack-tools/files/musepack-tools-495-fixup-link-depends.patch";
      #   sha256 = "sha256-KFdh3Hju+ncNgjGM2K9ZpLuZ9oLSLKnqZVbSM9O9SWk=";
      #   stripLen = 1;
      # })
      # (fetchpatch {
      #   url = "https://raw.githubusercontent.com/gentoo/gentoo/f5d4d4995d45baf77c176224b62e424dca037aef/media-sound/musepack-tools/files/musepack-tools-495-incompatible-pointers.patch";
      #   sha256 = "sha256-XK/LyH48VQDUMSHIXNlCwRLRJly4JjsaBvMFEX6SnD0=";
      #   stripLen = 1;
      # })
      # ./01_am-maintainer-mode.patch
      # ./02_link-libm.patch
      # ./04_link-order.patch
      # ./1001_missing_extern_kw.patch
      # ./musepack-tools-495-fix-compiler-warnings.patch
      #
      # ./mpcchap.patch
      # ./add_subdir-objects.patch
      # ./05_visibility.patch
      # ./musepack-tools-495-incompatible-pointers.patch
      # ./musepack-tools-495-fixup-link-depends.patch
      # ./musepack-tools-495-respect-cflags.patch
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

    buildPhase = ''
      # mkdir -p build
      # cd build
      #   cmake \
      #     -DCMAKE_C_FLAGS:STRING="$SLKCFLAGS" \
      #     -DCMAKE_INSTALL_PREFIX=/usr \
      #     -DLIB_SUFFIX=$LIBDIRSUFFIX \
      #     -DCMAKE_BUILD_TYPE=Release ..
      make -C include DESTDIR="$out" install
      make -C libmpcdec DESTDIR="$out" install
    '';

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
      # "-DBUILD_MPCCHAP=OFF"
      "-DREPLAY_GAIN_INCLUDE_DIR=${libreplaygain}/include/replaygain"
      "-DREPLAY_GAIN_LIBRARY=${libreplaygain}/lib/libreplaygain.so"
      "-DCUEFILE_INCLUDE_DIR=${libcuefile}/include"
      "-DCUEFILE_LIBRARY=${libcuefile}/lib/libcue.so"
    ];

    # NIX_CFLAGS_COMPILE = "-Wno-error=restrict";

    # outputs = ["out" "lib" "dev"];

    meta = {
      mainProgram = "mpcenc";
      description = "Encoder for the musepack format";
      homepage = "https://musepack.net";
      license = lib.licenses.lgpl2;
      platforms = lib.platforms.linux;
    };
  }
