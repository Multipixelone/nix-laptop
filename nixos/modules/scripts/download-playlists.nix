{pkgs}:
pkgs.writeShellApplication {
    name = "download-playlists";
    runtimeInputs = [pkgs.curl];
    text = ''
    '';
}