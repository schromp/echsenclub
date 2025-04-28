{
  pkgs,
  config,
  ...
}: {
  services.postgresql = {
    enable = true;
    dataDir = "/srv/postgres";
    # NOTE: Some Databases are set inside the services so not everything is listed here
  };
}
