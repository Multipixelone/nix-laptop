{ config, ... }:
{
  flake.modules.homeManager.base = {
    home.sessionVariables = {
      PLAYLIST_DIR = "${config.flake.meta.owner.username}/Music/Playlists";
    };
  };
}
