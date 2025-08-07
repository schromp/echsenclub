{
  inputs.clan-core.url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";
  inputs.nixpkgs.follows = "clan-core/nixpkgs";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  inputs.netbird-new-module.url = "github:NixOS/nixpkgs/pull/354032/head";
  inputs.zitadel-new-module.url = "github:schromp/nixpkgs/zitadel-database";

  outputs = {
    self,
    clan-core,
    ...
  } @ inputs: let
    clan = clan-core.lib.clan {
      inherit self;
      # Ensure this is unique among all clans you want to use.
      meta.name = "echsenclub";

      # All machines in ./machines will be imported.

      modules."netbird" = ./service-modules/netbird/netbird.nix;
      modules."acme" = ./service-modules/acme/acme.nix;
      inventory.instances = {
        user-lk = {
          module = {
            name = "users";
            input = "clan-core";
          };
          roles.default.tags.all = {};
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
          roles.default.tags.all = {};
        };
        sshd-basic = {
          module = {
            name = "sshd";
            input = "clan-core";
          };
          roles.server.tags.all = {};
          roles.client.tags.all = {};
        };
        netbird = {
          module.name = "netbird";
          module.input = "self";
          roles.relay.machines.cloudy = {};
          roles.signal.machines.cloudy = {};
          roles.management.machines.cloudy = {};
        };
        acme = {
          module = {
            name = "acme";
            input = "self";
          };
          roles.default.machines.cloudy = {
            settings = {
              email = "server@echsen.club";
              domains = [
                "sso.echsen.club"
                "sso-admin.echsen.club"
                "netbird.echsen.club"
              ];
              acceptTerms = true;
            };
          };
        };
      };

      specialArgs = {inherit inputs;};
    };
  in {
    inherit (clan.config) nixosConfigurations clanInternals;
    # Add the Clan cli tool to the dev shell.
    # Use "nix develop" to enter the dev shell.
    devShells =
      clan-core.inputs.nixpkgs.lib.genAttrs
      [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ]
      (system: {
        default = clan-core.inputs.nixpkgs.legacyPackages.${system}.mkShell {
          packages = let
            pkgs = clan-core.inputs.nixpkgs.legacyPackages.${system};
          in [
            clan-core.packages.${system}.clan-cli
            pkgs.opentofu
          ];
        };
      });
  };
}
