{...}: {
  services.grocy = {
    enable = true;
    hostname = "https://grocy.echsen.club";
    enableNginx = false;
    settings = {
      currency = "EUR";
      firstDayOfWeek = 1;
    };
  };
}
