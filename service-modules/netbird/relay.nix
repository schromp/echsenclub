{pkgs, config, inputs, ...}: {
  services.netbird.server = {
    relay = {
      enable = true;

      package = inputs.netbird-new-module.legacyPackages.${pkgs.system}.netbird-server;

      port = 33080;
      authSecretFile = config.clan.core.vars.generators."netbird-relay-auth".files."password".path;

      settings = {
        NB_EXPOSED_ADDRESS = "netbird.echsen.club";
      };
    };
  };
}
