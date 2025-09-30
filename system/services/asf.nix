{
  pkgs,
  config,
  inputs,
  ...
}:
{
  age.secrets = {
    "steam" = {
      file = "${inputs.secrets}/asf/steam.age";
      mode = "400";
      owner = "archisteamfarm";
      group = "archisteamfarm";
    };
  };
  networking.firewall.allowedTCPPorts = [
    1242
  ];
  services.archisteamfarm = {
    enable = true;
    web-ui.enable = true;
    bots.multipixelone = {
      passwordFile = config.age.secrets."steam".path;
      settings = {
        AcceptGifts = true;
        BotBehaviour = 8;
        CustomGamePlayedWhileFarming = "your mom";
        OnlineFlags = 1024;
        SteamTokenDumperPluginEnabled = true;
        EnableFreePackages = true; # TODO install FreePackages declaratively
        FreePackagesFilters = [
          { NoCostOnly = true; }
          { Categories = [ 29 ]; }
          {
            Types = [ "DLC" ];
            IgnoredTypes = [
              "Game"
              "Application"
            ];
          }
        ];
        SteamUserPermissions = {
          "76561198051516276" = 1;
          "76561198036181617" = 1;
        };
      };
    };
  };
}
