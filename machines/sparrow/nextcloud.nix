{
  config,
  pkgs,
  ...
}: {
  clan.core.vars.generators = {
    "nextcloud-admin-password" = {
      prompts.password.description = "The nextcloud admin password";
      prompts.password.type = "hidden";
      prompts.password.persist = true;

      files.password = {
        secret = true;
      };
    };
  };

  services.nextcloud = {
    enable = true;
    https = true;
    package = pkgs.nextcloud32;
    hostName = "nextcloud.echsen.club";
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) news contacts calendar tasks;
    };
    extraAppsEnable = true;

    database.createLocally = true;

    settings = {
      trusted_domains = ["nextcloud.echsen.club"];
      datadirectory = "/srv/nextcloud";
    };

    config = {
      adminpassFile = config.clan.core.vars.generators.nextcloud-admin-password.files.password.path;
      dbtype = "pgsql";
    };
  };
}
