{
  inputs.clan-core.url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";
  inputs.nixpkgs.follows = "clan-core/nixpkgs";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  inputs.netbird-new-module.url = "github:NixOS/nixpkgs/pull/354032/head";

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

      # modules."netbird" = import ./service-modules/netbird.nix;
      inventory.instances = {
        user-root = {
          module = {
            name = "users";
            input = "clan-core";
          };
          roles.default.tags.all = {};
          roles.default.settings = {
            user = "root";
            prompt = true;
          };
        };
        user-lk = {
          module = {
            name = "users";
            input = "clan-core";
          };
          roles.default.tags.all = {};
          roles.default.settings = {
            user = "lk";
            prompt = true;
          };
        };
        sshd-basic = {
          module = {
            name = "sshd";
            input = "clan-core";
          };
          roles.server.tags.all = {};
          roles.client.tags.all = {};
        };
      };

      # inventory.instances = {
      #   "netbird" = {
      #     roles.relay.machine = {
      #       "cloudy" = {
      #       };
      #     };
      #   };
      # };
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
