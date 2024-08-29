{
  stdenv,
  lib,
  pkgs,
}: let
  compat-list = pkgs.fetchurl {
    name = "citra-compat-list";
    url = "https://web.archive.org/web/20231111133415/https://api.citra-emu.org/gamedb";
    hash = "sha256-J+zqtWde5NgK2QROvGewtXGRAWUTNSKHNMG6iu9m1fU=";
  };
in
  stdenv.mkDerivation rec {
    pname = "citra-mirror";
    version = "2104";

    src = pkgs.fetchFromGitHub {
      owner = "PabloMK7";
      repo = "citra";
      rev = "5115f640c213e06857d4b0a04aabf1ef0208cb03";
      sha256 = "sha256-7l32wBJLunp/wjUc02uiXS8XRkJkm+ckLUQqWUKIHRQ=";
      fetchSubmodules = true;
    };
    nativeBuildInputs = with pkgs; [
      cmake
      pkg-config
      ffmpeg
      glslang
      qt6.wrapQtAppsHook
    ];

    buildInputs = with pkgs; [
      boost
      catch2_3
      cpp-jwt
      cryptopp
      # intentionally omitted: dynarmic - prefer vendored version for compatibility
      enet
      fmt
      httplib
      inih
      libusb1
      nlohmann_json
      openal
      openssl
      SDL2
      soundtouch
      spirv-tools
      vulkan-headers
      # intentionally omitted: xbyak - prefer vendored version for compatibility
      zstd
      qt6.qtbase
      qt6.qtmultimedia
      qt6.qtwayland
      qt6.qttools
      cubeb
      rapidjson
    ];

    cmakeFlags = [
      "-DUSE_SYSTEM_LIBS=ON"

      "-DDISABLE_SYSTEM_DYNARMIC=ON"
      "-DDISABLE_SYSTEM_GLSLANG=ON" # The following imported targets are referenced, but are missing: SPIRV-Tools-opt
      "-DDISABLE_SYSTEM_LODEPNG=ON" # Not packaged in nixpkgs
      "-DDISABLE_SYSTEM_VMA=ON"
      "-DDISABLE_SYSTEM_XBYAK=ON"

      # We don't want to bother upstream with potentially outdated compat reports
      "-DCITRA_ENABLE_COMPATIBILITY_REPORTING=ON"
      "-DENABLE_COMPATIBILITY_LIST_DOWNLOAD=OFF" # We provide this deterministically
      "-DUSE_DISCORD_PRESENCE=ON"
      "-DENABLE_QT_TRANSLATION=ON"
    ];

    hardeningDisable = ["fortify3"];

    postPatch = ''
      # Fix file not found when looking in var/empty instead of opt
      mkdir externals/dynarmic/src/dynarmic/ir/var
      ln -s ../opt externals/dynarmic/src/dynarmic/ir/var/empty

      # Prep compatibilitylist
      ln -s ${compat-list} ./dist/compatibility_list/compatibility_list.json

      # We already know the submodules are present
      substituteInPlace CMakeLists.txt \
        --replace "check_submodules_present()" ""

      # Add versions
      echo 'set(BUILD_FULLNAME "citra")' >> CMakeModules/GenerateBuildInfo.cmake

      # Add gamemode
      substituteInPlace externals/gamemode/include/gamemode_client.h --replace "libgamemode.so.0" "${lib.getLib pkgs.gamemode}/lib/libgamemode.so.0"
    '';

    postInstall = let
      libs = lib.makeLibraryPath [pkgs.vulkan-loader];
    in ''
      wrapProgram "$out/bin/citra" \
        --prefix LD_LIBRARY_PATH : ${libs}
      qtWrapperArgs+=(
        --prefix LD_LIBRARY_PATH : ${libs}
      )
    '';
  }
