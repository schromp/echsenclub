{...}: {
  services.tt-rss = {
    enable = true;
    selfUrlPath = "https://rss.echsen.club";
    virtualHost = "rss.echsen.club";
    registration.enable = false;
  };
}
