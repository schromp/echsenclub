{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./secrets/services-setup-key.nix
  ];

  services.netbird.clients."echsenclub" = {
    port = 51820;
    hardened = false;
    config = {
      ManagementURL = {
        Host = "netbird.echsen.club:443";
      };
    };
    environment = {
      NB_SETUP_KEY_FILE = config.clan.core.vars.generators."netbird-services-setup-key".files."netbird-services-setup-key".path;
    };
  };
}
