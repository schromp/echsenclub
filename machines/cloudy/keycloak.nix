{
  config,
  pkgs,
  ...
}: {
  services.keycloak = {
    enable = true;

    settings = {
      hostname = "https://sso.echsen.club";
      hostname-admin = "https://sso-admin.echsen.club";
      hostname-strict-https = true;
      http-enabled = true;
      http-port = 8080;
      http-management-port = 9000;
    };

    initialAdminPassword = "change-me-in-gui";
    database = {
      type = "postgresql";
      createLocally = true;
      passwordFile = config.clan.core.vars.generators."keycloak-db-password".files."keycloak-db-password".path;
    };
  };

  users.users.keycloak = {
    isSystemUser = true;
    createHome = false;
    group = "keycloak";
  };
  users.groups.keycloak = {};

  clan.core.vars.generators = {
    "keycloak-db-password" = {
      files."keycloak-db-password" = {
        owner = "keycloak";
        group = "keycloak";
        secret = true;
      };
      runtimeInputs = with pkgs; [
        coreutils
        pwgen
      ];
      script = ''
        echo -n "$(pwgen -s 32 1)" > "$out"/keycloak-db-password
      '';
    };
  };
}
