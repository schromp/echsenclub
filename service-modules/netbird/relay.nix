{pkgs, config, inputs, ...}: {
  services.netbird.server = {
    relay = {
      enable = true;

      package = pkgs.netbird-relay.overrideAttrs (oldAttrs: rec {
        version = "0.63.0";
        src = oldAttrs.src.override {
          tag = "v${version}";
          hash = "sha256-PNxwbqehDtBNKkoR5MtnmW49AYC+RdiXpImGGeO/TPg=";
        };
        vendorHash = "sha256-iTfwu6CsYQYwyfCax2y/DbMFsnfGZE7TlWE/0Fokvy4=";
      });

      port = 33080;
      authSecretFile = config.clan.core.vars.generators."netbird-relay-auth".files."password".path;

      settings = {
        NB_EXPOSED_ADDRESS = "rels://netbird.echsen.club:443";
      };
    };
  };
}
