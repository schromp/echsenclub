{
  pkgs,
  config,
  inputs,
  ...
}: {
  disabledModules = [
    "services/web-apps/zitadel.nix"
  ];
  imports = [
    (inputs.zitadel-new-module + "/nixos/modules/services/web-apps/zitadel.nix")
  ];

  services.zitadel = {
    enable = true;
    masterKeyFile = config.clan.core.vars.generators."zitadel-master-key".files."zitadel-master-key".path;
    tlsMode = "external";
    createDatabase = true;
    settings = {
      Port = 8082;
      ExternalDomain = "localhost";

      DefaultInstance = {
        InstanceName = "Zitadel";
        Org = {
          Name = "Zitadel";
        };
      };

      Database.postgres = {
        Host = "/run/postgresql";
        Port = 5432;
        Database = "zitadel";
        User = {
          Username = "zitadel";
          SSL.mode = "disable";
        };
        Admin = {
          Username = "zitadel";
          SSL.Mode = "disable";
        };
      };
    };

    steps = {
      FirstInstance = {
        InstanceName = "Zitadel";
        Org = {
          Name = "Zitadel";
          Human = {
            UserName = "zitadel-admin";
            FirstName = "Zitadel";
            LastName = "Admin";
          };
        };
      };
    };
    extraStepsPaths = [
      config.clan.core.vars.generators."zitadel-admin-user-password".files."zitadel-admin-user.yaml".path
    ];
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [
      "zitadel"
    ];
    ensureUsers = [
      {
        name = "zitadel";
        ensureDBOwnership = true;
        ensureClauses.superuser = true;
      }
    ];
    settings = {
      port = 5432;
    };

    initialScript = pkgs.writeText "zitadel-init.sql" ''
      CREATE SCHEMA IF NOT EXISTS eventstore;
      CREATE TABLE IF NOT EXISTS eventstore.events (
        id SERIAL PRIMARY KEY,
        data JSONB NOT NULL,
        created_at TIMESTAMP DEFAULT NOW()
      );
      CREATE TABLE IF NOT EXISTS eventstore.events2 (
        id SERIAL PRIMARY KEY,
        data JSONB NOT NULL,
        created_at TIMESTAMP DEFAULT NOW()
      );
    '';
  };

  clan.core.vars.generators = {
    "zitadel-master-key" = {
      files."zitadel-master-key" = {
        owner = "zitadel";
        group = "zitadel";
        secret = true;
      };
      runtimeInputs = with pkgs; [
        coreutils
        pwgen
      ];
      script = ''
        echo -n "$(pwgen -s 32 1)" > "$out"/zitadel-master-key
      '';
    };
    "zitadel-admin-user-password" = {
      files."zitadel-admin-user.yaml" = {
        owner = "zitadel";
        group = "zitadel";
        secret = true;
      };
      runtimeInputs = with pkgs; [
        coreutils
        pwgen
      ];
      script = ''
        password="$(pwgen -s 32 1)"

        cat > "$out"/zitadel-admin-user.yaml <<EOF
        DefaultInstance:
          Org:
            Name: Zitadel
            UserName: zitadel-admin
            Password: $password
        EOF
      '';
    };
  };

  # environment.etc."zitadel/config.yaml" = {
  #   mode = "0755";
  #   text = ''
  #     Log:
  #       Level: Info
  #     ExternalDomain: zitadel.echsen.club
  #     Port: 8082
  #     TLS:
  #       Enabled: true
  #     SMTPConfiguration:
  #       SMTP:
  #         Host: 127.0.0.1:1025
  #         User: ${config.clan.core.vars.generators."hydroxide".files."hydroxide-username".value}
  #       From: server.echsen.club
  #       FromName: Zitadel-Echsenclub
  #   '';
  # };
}
