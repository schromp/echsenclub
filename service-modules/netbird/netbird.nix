{
  _class = "clan.service";
  manifest.name = "netbird";
  roles.management = {
    interface = {};
    perInstance = {...}: {
      nixosModule = {...}: {
        imports = [
          ./shared.nix
          ./secrets/admin-password.nix
          ./secrets/datastore-encryption-key.nix
          ./secrets/relay-auth-secret.nix
          ./secrets/services-setup-key.nix
          ./secrets/keycloak-secret.nix
          ./management.nix
        ];
      };
    };
  };
  roles.relay = {
    interface = {};
    perInstance = {...}: {
      nixosModule = {...}: {
        imports = [
          ./shared.nix
          ./secrets/relay-auth-secret.nix
          ./relay.nix
        ];
      };
    };
  };
  roles.signal = {
    interface = {};
    perInstance = {...}: {
      nixosModule = {...}: {
        imports = [
          ./shared.nix
          ./signal.nix
        ];
      };
    };
  };
  # roles.client = {};
}
