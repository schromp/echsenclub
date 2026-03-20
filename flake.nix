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
        imports = [ ./clan.nix ];
        specialArgs = {
          inherit inputs; 
          libC = import ./lib { config = clan.config; };
        };
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
