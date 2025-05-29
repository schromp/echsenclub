{
  pkgs,
  config,
  ...
}: let
  apiUrl = "http://localhost:3001";
in {
  virtualisation.oci-containers.containers = {
    meilisearch = {
      image = "docker.io/getmeili/meilisearch:v1.12";
      ports = ["3002:7770"];
      environment = {
        MEILI_NO_ANALYTICS = "true";
        MEILI_ENV = "production";
      };
      environmentFiles = [
        config.clan.core.vars.generators."bar-assistant-env-file".files."secrets-env".path
      ];
      volumes = [
        "/var/lib/barassistant/meili_data:/meili_data"
      ];
      # Podman containers in NixOS are implicitly "restart: always" if enabled.
      # "unless-stopped" is the default behavior when enabling via NixOS.
    };

    bar-assistant = {
      image = "docker.io/barassistant/server:v5";
      podman.user = "barassistant";
      # depends_on is handled implicitly by being in the same pod and starting order
      # (NixOS generally starts services in dependency order, but within a pod,
      # services share network and can resolve each other after startup)
      environment = {
        APP_URL = apiUrl;
        # Meilisearch is within the same pod, accessible via its container name or localhost
        MEILISEARCH_HOST = "http://meilisearch:7700";
        CACHE_DRIVER = "file";
        SESSION_DRIVER = "file";
        ALLOW_REGISTRATION = "true";
      };
      ports = ["3001:3001"];
      environmentFiles = [
        config.clan.core.vars.generators."bar-assistant-env-file".files."secrets-env".path
      ];
      volumes = [
        "/var/lib/barassistant/app:/var/www/cocktails/storage/bar-assistant"
      ];
      dependsOn = [
        "meilisearch"
      ];
      extraOptions = [
        "--userns=keep-id"
      ];
    };

    salt-rim = {
      image = "docker.io/barassistant/salt-rim:v4";
      environment = {
        API_URL = apiUrl;
      };
      ports = ["3000:3000"];
      environmentFiles = [
        config.clan.core.vars.generators."bar-assistant-env-file".files."secrets-env".path
      ];
      dependsOn = [
        "bar-assistant"
      ];
    };
  };

  users.users.barassistant = {
    isSystemUser = true;
    createHome = false;
    home = "/var/lib/barassistant";
    group = "barassistant";
    autoSubUidGidRange = true;
    subUidRanges = [
      {
        startUid = 100000;
        count = 65536;
      }
    ];
    subGidRanges = [
      {
        startGid = 100000;
        count = 65536;
      }
    ];
  };
  users.groups.barassistant = {};

  systemd.tmpfiles.rules = [
    "d /var/lib/barassistant 0750 barassistant barassistant -"
    "d /var/lib/barassistant/app 0750 barassistant barassistant -"
    "d /var/lib/barassistant/meili_data 0750 barassistant barassistant -"
  ];

  clan.core.vars.generators = {
    "bar-assistant-master-key" = {
      files."key" = {
        secret = true;
      };
      runtimeInputs = with pkgs; [
        coreutils
        pwgen
      ];
      script = ''
        echo -n "$(pwgen -s 32 1)" > "$out"/key
      '';
    };

    "bar-assistant-env-file" = {
      dependencies = [
        "bar-assistant-master-key"
      ];
      files."secrets-env" = {
        secret = true;
        owner = "barassistant";
      };

      runtimeInputs = with pkgs; [
        coreutils
      ];

      script = ''
        cat > "$out/secrets-env" <<EOF
        MEILI_MASTER_KEY=$(cat "$in/bar-assistant-master-key/key")
        EOF
      '';
    };
  };
}
