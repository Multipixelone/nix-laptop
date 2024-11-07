{
  # pkgs,
  # lib,
  ...
}: {
  imports = [
    ./desktop.nix
    ./programs/gaming/default.nix
  ];
  tunnel.yabridge.enable = true;
  home.file.".config/environment.d/gamescope-session.conf".text = ''
    if [ "$XDG_SESSION_DESKTOP" = "gamescope" ] ; then
        SCREEN_WIDTH=3840
        SCREEN_HEIGHT=2160
        CONNECTOR=HDMI-A-1
        CLIENTCMD="steam -gamepadui -steamos3 -steampal -steamdeck -pipewire-dmabuf"
        GAMESCOPECMD="/usr/bin/gamescope --hdr-enabled --hdr-itm-enable \
        --hide-cursor-delay 3000 --fade-out-duration 200 --xwayland-count 2 \
        -W $SCREEN_WIDTH -H $SCREEN_HEIGHT -O $CONNECTOR"
    fi
  '';
  # systemd.user.services.ledfx = {
  #   Unit.Description = "ledfx light control";
  #   Install.WantedBy = ["graphical-session.target"];
  #   Service = {
  #     ExecStart = lib.getExe pkgs.ledfx;
  #   };
  # };
}
