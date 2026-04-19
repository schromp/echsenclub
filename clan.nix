{
  meta = {
    name = "echsenclub";
    domain = "echsen.club";
  };

  modules."common" = ./service-modules/common/common.nix;
  modules."netbird" = ./service-modules/netbird/netbird.nix;
  modules."acme" = ./service-modules/acme/acme.nix;
  modules."opentelemetry" = ./service-modules/opentelemetry/collector.nix;

  inventory.machines = {
    cloudy = {
      deploy.targetHost = "root@157.180.37.119";
      tags = [
        "shared"
      ];
    };

    doorman = {
      deploy.targetHost = "root@195.201.96.101";
      tags = [
        "shared"
      ];
    };

    sparrow = {
      deploy.targetHost = "root@sparrow.internal.echsen.club";
      tags = [
        "personal-schromp"
      ];
    };
  };

  inventory.instances = {
    common = {
      module = {
        name = "common";
        input = "self";
      };
      roles.default.tags.all = { };
    };

    user-lk = {
      module = {
        name = "users";
        input = "clan-core";
      };
      roles.default.tags."personal-schromp" = { };
      roles.default.tags.shared = { };
      roles.default.settings = {
        user = "lk";
        prompt = true;
        groups = [
          "wheel"
        ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRat12+538VwG/IAv5R4AjdNYz/GATO7ULQnXtYC2HK lk@tower"
        ];
      };
    };

    user-goshva = {
      module = {
        name = "users";
        input = "clan-core";
      };
      roles.default.tags.shared = { };
      roles.default.settings = {
        user = "goshva";
        prompt = true;
        groups = [
          "wheel"
        ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHAUuSmWi39PhH40pw49q6TGgRAMwmxsFdDSLWHgNQ73 goshva@galahad"
        ];
      };
    };

    root-user = {
      module = {
        name = "users";
        input = "clan-core";
      };
      roles.default.tags.all = { };
      roles.default.settings = {
        user = "root";
        prompt = true;
      };
    };

    sshd-shared = {
      module = {
        name = "sshd";
        input = "clan-core";
      };
      roles.server.settings = {
        authorizedKeys = {
          "schromp-key" =
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRat12+538VwG/IAv5R4AjdNYz/GATO7ULQnXtYC2HK lk@tower";
          "goshva-key" =
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHAUuSmWi39PhH40pw49q6TGgRAMwmxsFdDSLWHgNQ73 goshva@galahad";
        };
      };
      roles.server.tags.shared = { };
    };

    sshd-private-schromp = {
      module = {
        name = "sshd";
        input = "clan-core";
      };
      roles.server.settings = {
        authorizedKeys = {
          "schromp-key" =
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRat12+538VwG/IAv5R4AjdNYz/GATO7ULQnXtYC2HK lk@tower";
        };
      };
      roles.server.tags."personal-schromp" = { };
    };

    netbird = {
      module.name = "netbird";
      module.input = "self";
      roles.management.settings = {
        domain = "netbird.echsen.club";
      };
      roles.relay.machines.doorman = { };
      roles.signal.machines.doorman = { };
      roles.management.machines.doorman = { };

      roles.client.tags.all = { };
    };

    opentelemetry = {
      module.name = "opentelemetry";
      module.input = "self";
      roles.default.settings = {
        clickhouse = "tcp://sparrow.internal.echsen.club:9900";
        monitorNginx = true;
        monitorJournald = true;
      };
      roles.default.tags.all = { };
      roles.default.machines.cloudy.settings = {
        prometheusTargets = [ "localhost:9090" ];
      };
    };

    borgbackup = {
      module = {
        name = "borgbackup";
        input = "clan-core";
      };

      roles.client.machines.sparrow.settings = {
        startAt = "*-*-* 02:30:00";
      };

      roles.server.machines = {
        sparrow.settings = {
          address = "sparrow.internal.echsen.club";
          directory = "/backup/borgbackup";
        };
      };
    };
  };
}
