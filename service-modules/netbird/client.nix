{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./secrets/services-setup-key.nix
  ];

  services.netbird.package = pkgs.netbird.overrideAttrs (oldAttrs: rec {
    version = "0.63.0";
    src = oldAttrs.src.override {
      tag = "v${version}";
      hash = "sha256-PNxwbqehDtBNKkoR5MtnmW49AYC+RdiXpImGGeO/TPg=";
    };
    vendorHash = "sha256-iTfwu6CsYQYwyfCax2y/DbMFsnfGZE7TlWE/0Fokvy4=";
  });
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
