{
  nixpkgs.config.allowUnfreePackages = [
    "n8n"
  ];
  configurations.nixos.link.module = {
    services.n8n = {
      enable = true;
      openFirewall = true;
      environment.N8N_SECURE_COOKIE = false;
    };
  };
}
