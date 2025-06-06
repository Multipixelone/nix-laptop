_:
# subway = self.packages.${pkgs.system}.subway;
{
  systemd = {
    tmpfiles.rules = [
      "d /srv/valhalla 0770 tunnel users -"
    ];
  };
  virtualisation.oci-containers = {
    containers = {
      valhalla = {
        autoStart = false;
        image = "ghcr.io/gis-ops/docker-valhalla/valhalla:latest";
        ports = ["8002:8002"];
        volumes = [
          "/srv/valhalla:/custom_files"
          #"${subway}:/gtfs_feeds"
        ];
        environment = {
          tile_urls = "http://download.geofabrik.de/north-america/us-northeast-latest.osm.pbf";
          server_threads = "8";
          serve_tiles = "True";
          build_elevation = "True";
          build_transit = "True";
          build_admins = "True";
          build_time_zones = "True";
          build_tar = "True";
          force_rebuild = "False";
        };
      };
    };
  };
}
