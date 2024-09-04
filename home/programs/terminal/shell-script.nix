{pkgs, ...}: let
  upload-script = pkgs.writeShellApplication {
    name = "0x0";
    runtimeInputs = with pkgs; [curl coreutils wl-clipboard];
    text = ''
      file_upload() {
        local file="$1"
        printf "uploading \"%s\"...\n" "''${file}" >&2
        url=$(curl -s -F "file=@''${file}" "https://0x0.st")
        printf "%s" "''${url}"
        # TODO negate this? I don't like having to have an else here
        if [ -z "''${WAYLAND_DISPLAY+x}" ]; then
          return;
        else
          wl-copy "''${url}";
        fi
        # TODO rewrite this to not fail shellcheck. see: https://www.shellcheck.net/wiki/SC2059
        # shellcheck disable=SC2059
        printf "\n$(date)\n\t''${file}\n\t\t''${url}" >> ~/.config/0x0.history
      }
      file_upload "''${@}"
    '';
  };
in {
  home.packages = [
    upload-script
  ];
}
