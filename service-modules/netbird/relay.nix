{pkgs, config, inputs, ...}: {
  services.netbird.server = {
    relay = {
      enable = true;

      package = pkgs.netbird-relay;

      port = 33080;
      authSecretFile = config.clan.core.vars.generators."netbird-relay-auth".files."password".path;

      settings = {
        NB_EXPOSED_ADDRESS = "rels://netbird.echsen.club:443";
      };
    };
  };
}
