{config, ...}: {
  services.netbird.server.coturn = {
    enable = true;
    useAcmeCertificates = true;
    domain = "coturn-cloudy.echsen.club";
    user = "netbird";
    passwordFile = config.clan.core.vars.generators."coturn-password".files."password".path;
  };
}
