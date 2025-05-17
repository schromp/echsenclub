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
    "zitadel-admin-user" = {
      files."zitadel-master-key" = {
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
  };

  environment.etc."zitadel/config.yaml" = {
    mode = "0755";
    text = ''
      Log:
        Level: Info
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
      Zitadel:
        InstanceName: Zitadel
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
      "/run/hydroxide-zitadel.yaml"
      "--steps"
      "/etc/zitadel/steps.yaml"
      "--tlsMode"
      "external"
    ];
    extraOptions = ["--network=host"];
    # ports = ["8082:8080"];
    volumes = [
      "${config.clan.core.vars.generators."zitadel-master-key".files."zitadel-master-key".path}:/run/masterfileKey"
      "${config.clan.core.vars.generators."hydroxide".files."hydroxide-zitadel-secret".path}:/run/hydroxide-zitadel.yaml"
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
    volumes = [
      "/var/lib/postgresql-zitadel/data:/var/lib/postgresql/data"
    ];
  };

  # systemd.tmpfiles.rules = [
  #   "d /var/lib/postgresql-zitadel/data 0750 postgres postgres -"
  # ];
}
