{
  virtualisation.quadlet.containers.plexamp-headless = {
    autoStart = false;
    serviceConfig = {
      RestartSec = "10";
      Restart = "always";
    };
    containerConfig = {
      image = "ghcr.io/multipixelone/plexamp:amd64";
      pull = "newer";
      volumes = [
        "/srv/plexamp:/root/.local/share/Plexamp/Settings"
        "/run/user/1000/pipewire-0:/tmp/pipewire-0"
        # "/run/dbus/system_bus_socket:/run/dbus/system_bus_socket"
      ];
      environments = {
        XDG_RUNTIME_DIR = "/tmp";
      };
      publishPorts = [
        "0.0.0.0:32400:32400"
        "0.0.0.0:32500:32500"
        "0.0.0.0:20000:20000"
      ];
    };
  };
}
