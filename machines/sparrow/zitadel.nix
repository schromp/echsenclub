{
  pkgs,
  config,
  ...
}: {
  clan.core.vars.generators = {
    "zitadel-master-key" = {
      files."zitadel-master-key" = {
        # owner = "1000";
        # group = "1000";
        secret = false;
      };
      runtimeInputs = with pkgs; [
        coreutils
        pwgen
      ];
      script = ''
        echo -n "$(pwgen -s 32 1)" > "$out"/zitadel-master-key
      '';
    };
    "zitadel-db-password" = {
      files."zitadel-db-password" = {
        owner = "zitadel";
        group = "zitadel";
        secret = false;
      };
      runtimeInputs = with pkgs; [
        coreutils
        pwgen
      ];
      script = ''
        echo -n "$(pwgen -s 32 1)" > "$out"/zitadel-db-password
      '';
    };
  };

  environment.etc."zitadel/config.yaml" = {
    mode = "0755";
    text = ''
      ExternalDomain: zitadel.echsen.club
      Port: 8082
      TLS:
        Enabled: true
      SMTPConfiguration:
        SMTP:
          Host: 127.0.0.1:1025
          User: ${config.clan.core.vars.generators."hydroxide".files."hydroxide-username".value}
        From: server.echsen.club
        FromName: Zitadel-Echsenclub
    '';
  };

  environment.etc."zitadel/steps.yaml" = {
    mode = "0755";
    text = ''
      Echsenclub:
        InstanceName: Echsenclub
        Org:
          Human:
            FirstName: echsenclub
            LastName: admin
            UserName: admin
    '';
  };

  virtualisation.oci-containers.containers.zitadel = {
    pull = "missing";
    image = "ghcr.io/zitadel/zitadel:latest";
    cmd = [
      "start-from-init"
      "--masterkeyFile"
      "/run/masterfileKey"
      "--tlsMode"
      "disabled"
      "--config"
      "/etc/zitadel/config.yaml"
      "--config"
      "${config.clan.core.vars.generators."hydroxide".files."hydroxide-zitadel-secret".path}"
      "--steps"
      "/etc/zitadel/steps.yaml"
      "--tlsMode"
      "external"
    ];
    extraOptions = ["--network=host"];
    # ports = ["8082:8080"];
    volumes = [
      "${config.clan.core.vars.generators."zitadel-master-key".files."zitadel-master-key".path}:/run/masterfileKey"
      "/etc/zitadel:/etc/zitadel"
    ];
    environment = {
      ZITADEL_DATABASE_POSTGRES_HOST = "host.docker.internal";
      ZITADEL_DATABASE_POSTGRES_PORT = "5433";
      ZITADEL_DATABASE_POSTGRES_DATABASE = "zitadel";
      ZITADEL_DATABASE_POSTGRES_USER_USERNAME = "zitadel";
      ZITADEL_DATABASE_POSTGRES_USER_PASSWORD = "zitadel";
      ZITADEL_DATABASE_POSTGRES_USER_SSL_MODE = "disable";
      ZITADEL_DATABASE_POSTGRES_ADMIN_USERNAME = "postgres";
      ZITADEL_DATABASE_POSTGRES_ADMIN_PASSWORD = "postgres";
      ZITADEL_DATABASE_POSTGRES_ADMIN_SSL_MODE = "disable";
      ZITADEL_EXTERNALSECURE = "false";
    };
    dependsOn = ["zitadel-db"];
  };

  virtualisation.oci-containers.containers.zitadel-db = {
    pull = "missing";
    image = "postgres:17-alpine";
    ports = ["5433:5432"];
    environment = {
      PGUSER = "postgres";
      POSTGRES_PASSWORD = "postgres";
    };
  };
}
