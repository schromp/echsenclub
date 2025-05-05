{
  pkgs,
  config,
  ...
}: {
  services.postgresql = {
    enable = true;
    # NOTE: Some Databases are set inside the services so not everything is listed here
  };
}
