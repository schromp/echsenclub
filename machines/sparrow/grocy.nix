{...}: {
  services.grocy = {
    enable = true;
    hostName = "grocy.echsen.club";
    nginx.enableSSL = false;
    settings = {
      culture = "de";
      currency = "EUR";
      calendar.firstDayOfWeek = 1;
    };
  };
}
