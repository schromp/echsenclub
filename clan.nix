{
  meta = {
    name = "echsenclub";
    domain = "echsen.club";
  };

  modules."netbird" = ./service-modules/netbird/netbird.nix;
  modules."netbird2" = ./service-modules/netbird2/netbird.nix;
  modules."acme" = ./service-modules/acme/acme.nix;
  modules."opentelemetry" = ./service-modules/opentelemetry/collector.nix;

  inventory.instances = {
    user-lk = {
      module = {
        name = "users";
        input = "clan-core";
      };
      roles.default.tags.all = { };
      roles.default.settings = {
        user = "lk";
        prompt = true;
        groups = [
          "wheel"
        ];
      };
    };

    admin = {
      module.name = "admin";
      roles.default.settings = {
        allowedKeys = {
          key1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRat12+538VwG/IAv5R4AjdNYz/GATO7ULQnXtYC2HK lk@tower ";
        };
      };
      roles.default.tags.all = { };
    };

    netbird = {
      module.name = "netbird";
      module.input = "self";
      roles.relay.machines.cloudy = { };
      roles.signal.machines.cloudy = { };
      roles.management.machines.cloudy = { };
      roles.client.machines = {
        sparrow = { };
        cloudy = { };
      };
    };
    netbird2 = {
      module.name = "netbird2";
      module.input = "self";
      roles.management.settings = {
        domain = "netbird2.echsen.club";
      };
      roles.relay.machines.doorman = { };
      roles.signal.machines.doorman = { };
      roles.management.machines.doorman = { };
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
  };
}
