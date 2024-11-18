{
  pkgs,
  config,
  lib,
  ...
}: let
  # TODO run tuigreet inside of kmscon
  # kmscon = "${pkgs.kmscon}/libexec/kmscon/kmscon";
  tuigreet = lib.getExe' pkgs.greetd.tuigreet "tuigreet";
  # hyprland = lib.getExe' config.programs.hyprland.package "Hyprland";
  hyprland-session = "${config.programs.hyprland.package}/share/wayland-sessions";
in {
  # required for keyring to unlock on boot
  security.pam.services.greetd.enableGnomeKeyring = true;
  services = {
    seatd.enable = true;
    kmscon = {
      enable = true;
      extraConfig = "font-size=24";
      fonts = [
        {
          name = "PragmataPro Liga";
          package = pkgs.callPackage ../../pkgs/pragmata {};
        }
      ];
    };
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${tuigreet} --greeting \"hi finn :)\" --time --remember --remember-session --sessions ${hyprland-session}";
          user = "greeter";
        };
        # autologin on desktop: I'm gonna do a big refactor to modules soon™ 🙏
        initial_session = lib.mkIf (config.networking.hostName == "link") {
          command = "${lib.getExe config.programs.uwsm.package} start hyprland-uwsm.desktop";
          user = "tunnel";
        };
      };
    };
  };
  programs.uwsm = {
    enable = true;
    waylandCompositors.hyprland = {
      binPath = "/run/current-system/sw/bin/Hyprland";
      prettyName = "Hyprland";
      comment = "Hyprland managed by UWSM";
    };
  };
  # this is a life saver.
  # literally no documentation about this anywhere.
  # might be good to write about this...
  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
