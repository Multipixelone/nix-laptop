{
  config,
  lib,
  ...
}:
# TODO run tuigreet inside of kmscon
# kmscon = "${pkgs.kmscon}/libexec/kmscon/kmscon";
# tuigreet = lib.getExe' pkgs.greetd.tuigreet "tuigreet";
# hyprland = lib.getExe' config.programs.hyprland.package "Hyprland";
# hyprland-session = "${config.programs.hyprland.package}/share/wayland-sessions";
{
  # required for keyring to unlock on boot
  security.pam.services.greetd.enableGnomeKeyring = true;
  services = {
    # seatd.enable = true;
    # kmscon = {
    #   enable = true;
    #   extraConfig = "font-size=24";
    #   fonts = [
    #     {
    #       name = "PragmataPro Liga";
    #       package = pkgs.callPackage ../../pkgs/pragmata {};
    #     }
    #   ];
    # };
    greetd =
      let
        session = {
          command = "${lib.getExe config.programs.uwsm.package} start hyprland-uwsm.desktop";
          user = "tunnel";
        };
      in
      {
        enable = true;
        settings = {
          initial_session = session;
          default_session = session;
          # default_session = {
          #   command = "${tuigreet} --greeting \"hi finn :)\" --time --remember --remember-session --sessions ${hyprland-session}";
          #   user = "greeter";
          # };
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
