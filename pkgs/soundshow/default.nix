{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  gtk3,
  zlib,
  alsa-lib,
  dbus,
  libGL,
  libXcursor,
  libXext,
  libXi,
  libXinerama,
  libxkbcommon,
  libXrandr,
  libXScrnSaver,
  libXxf86vm,
  udev,
  vulkan-loader, # (not used by default, enable in settings menu)
  wayland, # (not used by default, enable with SDL_VIDEODRIVER=wayland - doesn't support HiDPI)
  makeDesktopItem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soundshow";
  # version = "1.0.0.4080";
  version = "2025.12.14";

  src = fetchzip {
    url = "https://github.com/soundshow-app/soundshow-downloads/releases/download/v${finalAttrs.version}/SoundShow-linux-x64.zip";
    hash = "sha256-3v4Pr+eibp2w9CEJYDSpdLwr88Zkxgwkq64e6/+UU3Y=";
  };

  # outputs = [
  #   "out"
  #   "doc"
  # ];

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    # Load-time libraries (loaded from DT_NEEDED section in ELF binary)
    alsa-lib
    gtk3
    stdenv.cc.cc.lib
    zlib

    # Run-time libraries (loaded with dlopen)
    dbus
    libGL
    libXcursor
    libXext
    libXi
    libXinerama
    libxkbcommon
    libXrandr
    libXScrnSaver
    libXxf86vm
    udev
    vulkan-loader
    wayland
  ];

  desktopItem = makeDesktopItem {
    name = "soundshow";
    desktopName = "SoundShow";
    comment = finalAttrs.meta.description;
    icon = "soundshow";
    exec = "soundshow";
    categories = [ "Audio" ];
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 SoundShow.x86_64 "$out/bin/soundshow"
    install -Dm644 UnityPlayer.so "$out/libexec/soundshow/UnityPlayer.so"

    mkdir -p "$out/share/pixmaps"
    cp -r SoundShow_Data "$out/share/soundshow"
    ln -s "$out/share/soundshow" "$out/bin/SoundShow_Data"
    # ln -s "$out/share/clonehero/Resources/UnityPlayer.png" "$out/share/pixmaps/clonehero.png"
    install -Dm644 "$desktopItem/share/applications/soundshow.desktop" "$out/share/applications/soundshow.desktop"

    # mkdir -p "$doc/share/doc/clonehero"
    # cp -r CLONE_HERO_MANUAL.{pdf,txt} Custom EULA.txt THIRDPARTY.txt "$doc/share/doc/clonehero"

    runHook postInstall
  '';

  # Patch required run-time libraries as load-time libraries
  #
  # Libraries found with:
  # > strings UnityPlayer.so | grep '\.so'
  # and:
  # > LD_DEBUG=libs clonehero
  postFixup = ''
    patchelf \
      --add-needed libasound.so.2 \
      --add-needed libdbus-1.so.3 \
      --add-needed libGL.so.1 \
      --add-needed libpthread.so.0 \
      --add-needed libudev.so.1 \
      --add-needed libvulkan.so.1 \
      --add-needed libwayland-client.so.0 \
      --add-needed libwayland-cursor.so.0 \
      --add-needed libwayland-egl.so.1 \
      --add-needed libX11.so.6 \
      --add-needed libXcursor.so.1 \
      --add-needed libXext.so.6 \
      --add-needed libXi.so.6 \
      --add-needed libXinerama.so.1 \
      --add-needed libxkbcommon.so.0 \
      --add-needed libXrandr.so.2 \
      --add-needed libXss.so.1 \
      --add-needed libXxf86vm.so.1 \
      "$out/libexec/soundshow/UnityPlayer.so"
  '';

  meta = with lib; {
    description = "Clone of Guitar Hero and Rockband-style games";
    homepage = "https://clonehero.net";
    license = licenses.unfree;
    maintainers = with maintainers; [
      kira-bruneau
      syboxez
    ];
    platforms = [ "x86_64-linux" ];
  };
})
