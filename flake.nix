{
  inputs = {
    clan-core.url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";
    nixpkgs.follows = "clan-core/nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    netbird-new-module.url = "github:NixOS/nixpkgs/pull/354032/head";
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
        inventory.instances = {
          # borgbackup = import ./clan/borgbackup.nix;
          matrix-synapse = {
            module = {
              name = "matrix-synapse";
              input = "clan-core";
            };
            roles.default.machines.cloudy.settings = {
              acmeEmail = "server@echsen.club";
              app_domain = "matrix.echsen.club";
              server_tld = "echsen.club";
              users = {
                schromp = {
                  name = "schromp";
                  admin = true;
                };
              };
            };
          };
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
          sshd-basic = {
            module = {
              name = "sshd";
              input = "clan-core";
            };
            roles.server.tags.all = { };
            roles.client.tags.all = { };
          };
          netbird = {
            module.name = "netbird";
            module.input = "self";
            roles.relay.machines.cloudy = { };
            roles.signal.machines.cloudy = { };
            roles.management.machines.cloudy = { };
            roles.coturn.machines.cloudy = { };
            roles.client.machines = {
              sparrow = { };
              cloudy = { };
            };
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
                    "pds.echsen.club"
                  ];
                  acceptTerms = true;
                };
              };
              sparrow = {
                settings = {
                  email = "server@echsen.club";
                  domains = [
                    "jellyfin.echsen.club"
                    "audiobookshelf.echsen.club"
                    "jellyseerr.echsen.club"
                    "sonarr.echsen.club"
                    "radarr.echsen.club"
                    "sabnzbd.echsen.club"
                    "prowlarr.echsen.club"
                    "readarr.echsen.club"
                    "pdf.echsen.club"
                    "kavita.echsen.club"
                    "nextcloud.echsen.club"
                    "rss.echsen.club"
                    "immich.echsen.club"
                    "signoz.echsen.club"
                    "git.echsen.club"
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
