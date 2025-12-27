{
  lib,
  pkgs,
  config,
  ...
}:
let
  sunpaper = pkgs.sunpaper.overrideAttrs (oldAttrs: {
    postPatch = ''
      substituteInPlace sunpaper.sh \
        --replace-fail "sunwait" "${lib.getExe pkgs.sunwait}" \
        --replace-fail "setwallpaper" "${lib.getExe' pkgs.wallutils "setwallpaper"}" \
        --replace-fail '$HOME/sunpaper/images/Corporate-Synergy' "$out/share/sunpaper/images/Lakeside" \
        --replace-fail '/usr/share' '/etc'
    '';
    buildInputs = oldAttrs.buildInputs ++ [
      pkgs.swww
      pkgs.bc
    ];
  });
in
{
  imports = [
    ./programs/hyprland/modules/battery.nix
  ];
  home.sessionVariables = lib.mkForce {
    MUSIC_DIR = "${config.xdg.userDirs.music}/Library";
    TRANSCODED_MUSIC = "${config.xdg.userDirs.music}/Library";
    ARTWORK_DIR = "${config.xdg.userDirs.music}/RockboxCover";
    MOPIDY_PLAYLISTS = "/home/tunnel/.local/share/mopidy/m3u";
    IPOD_DIR = "/run/media/tunnel/FINNR_S IPO";
    PLAYLIST_DIR = "/home/tunnel/Music/Playlists";
  };
  xdg.configFile."sunpaper/config".text = ''
    latitude="40.680271N"
    longitude="73.944893W"

    swww_enable="true"
    swww_fps="240"
    swww_step="30"
  '';
  systemd.user = {
    timers.sunpaper = {
      Install.WantedBy = [ "timers.target" ];
      Timer = {
        OnCalendar = "*:0/1";
      };
    };
    services.sunpaper = {
      Unit.Description = "automatic wallpaper set based on sun";
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        ExecStart = lib.getExe sunpaper;
      };
    };
    services.sunpaper-cache = {
      Unit.Description = "clear sunpaper cache on startup";
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        Type = "oneshot";
        RemainAfterExit = "no";
        ExecStart = "${lib.getExe sunpaper} -c";
      };
    };
  };
  programs.looking-glass-client = {
    enable = true;
    settings = {
      app.shmFile = "/dev/kvmfr0";
      app.allowDMA = "yes";
      input.escapeKey = 119;
      input.rawMouse = "yes";
      spice.enable = "yes";
      win.autoScreensaver = "yes";
      win.fullScreen = "yes";
      win.jitRender = "yes";
      win.quickSplash = "yes";
      wayland.fractionScale = "no";
    };
  };
  home.packages = [
    sunpaper
    (pkgs.writeScriptBin "win" ''
      #!${lib.getExe pkgs.fish}
      #!/usr/bin/env fish
      set VM_NAME "win11"
      set STATE (virsh --connect qemu:///system domstate $VM_NAME 2>/dev/null)
      if string match -q "running*" $STATE
          echo "$VM_NAME is already running."
      else
          echo "Starting $VM_NAME..."
          virsh --connect qemu:///system start $VM_NAME
          sleep 3
      end

      set -e WAYLAND_DISPLAY
      looking-glass-client &
      exit
    '')
    (pkgs.makeDesktopItem {
      name = "windows";
      desktopName = "Windows VM";
      exec = "win";
      terminal = false;
      type = "Application";
      icon = "windows95";
    })
  ];
}
