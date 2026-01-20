{lib, ...}: {
  services.grocy = {
    enable = true;
    hostName = "grocy.echsen.club";
    settings = {
      culture = "de";
      currency = "EUR";
      calendar.firstDayOfWeek = 1;
    };
  };
  services.nginx.virtualHosts."grocy.echsen.club" = lib.mkForce { };
  # services.phpfpm.pools.grocy = {
  #   user = "grocy";
  #   group = "caddy";
  #   # socketMode = "0660";
  # };
  users.users.grocy.group = lib.mkForce "caddy";
}
