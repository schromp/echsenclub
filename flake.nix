{
  inputs = {
    clan-core.url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";
    nixpkgs.follows = "clan-core/nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    netbird-new-module.url = "github:schromp/nixpkgs/fix-netbird";
    tangled.url = "git+https://tangled.org/@tangled.org/core";
    copyparty.url = "github:9001/copyparty";
    jellyswarm = {
      url = "github:LLukas22/Jellyswarrm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      clan-core,
      nixpkgs,
      ...
    }@inputs:
    let
      clan = clan-core.lib.clan {
        inherit self;

        # imports = [ ./clan/clan.nix ];
        # Ensure this is unique among all clans you want to use.
        meta.name = "echsenclub";

        # All machines in ./machines will be imported.

        modules."netbird" = ./service-modules/netbird/netbird.nix;
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
                "libvirtd"
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
          opentelemetry = {
            module.name = "opentelemetry";
            module.input = "self";
            roles.default.settings = {
              clickhouse = "tcp://sparrow.internal.echsen.club:9900";
              monitorNginx = true;
              monitorJournald = true;
            };
            roles.default.tags.all = {};
          };
          acme = {
            module = {
              name = "acme";
              input = "self";
            };
            roles.default.machines = {
              cloudy = {
                settings = {
                  email = "server@echsen.club";
                  domains = [
                    "sso.echsen.club"
                    "sso-admin.echsen.club"
                    "netbird.echsen.club"
                    "coturn-cloudy.echsen.club"
                    "matrix.echsen.club"
                    "matrix-admin.echsen.club"
                    "maubot.echsen.club"
                    "knot.echsen.club"
                    "spindle.echsen.club"
                    "grafana.echsen.club"
                  ];
                  acceptTerms = true;
                };
              };
            };
          };
        };

        specialArgs = { inherit inputs; };
      };
    in
    {
      inherit (clan.config) nixosConfigurations nixosModules clanInternals;
      # Add the Clan cli tool to the dev shell.
      # Use "nix develop" to enter the dev shell.
      clan = clan.config;
      devShells =
        nixpkgs.lib.genAttrs
          [
            "x86_64-linux"
            "aarch64-linux"
            "aarch64-darwin"
            "x86_64-darwin"
          ]
          (system: {
            default = clan-core.inputs.nixpkgs.legacyPackages.${system}.mkShell {
              packages = [ clan-core.packages.${system}.clan-cli ];
            };
          });
    };
}
