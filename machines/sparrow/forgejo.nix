{...}: {
  services.forgejo = {
    enable = true;
    database.type = "postgres";
    secrets = {
    };
    settings = {
      server = {
        DOMAIN = "git.echsen.club";
        ROOT_URL = "https://git.echsen.club";
        HTTP_PORT = 3000;
      };
    };
  };
}
