{
  pkgs,
  config,
  lib,
  ...
}: let
  # TODO run tuigreet inside of kmscon
  kmscon = "${pkgs.kmscon}/libexec/kmscon/kmscon";
  tuigreet = lib.getExe' pkgs.greetd.tuigreet "tuigreet";
  hyprland = lib.getExe' config.programs.hyprland.package "Hyprland";
  hyprland-session = "${config.programs.hyprland.package}/share/wayland-sessions";
in {
  services.seatd.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --greeting \"hi finn :)\" --time --remember --remember-session --sessions ${hyprland-session}";
        user = "greeter";
      };
      initial_session = {
        command = "${hyprland}";
        user = "tunnel";
      };
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
