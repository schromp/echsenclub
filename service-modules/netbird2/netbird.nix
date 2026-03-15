{
  _class = "clan.service";
  manifest.name = "netbird";
  roles.relay = {
    interface = { };
    perInstance =
      { ... }:
      {
        nixosModule =
          { ... }:
          {
            imports = [
              ./secrets/relay-auth-secret.nix
              ./relay.nix
            ];
          };
      };
  };
  roles.signal = {
    interface = { };
    perInstance =
      { ... }:
      {
        nixosModule =
          { ... }:
          {
            imports = [
              ./signal.nix
            ];
          };
      };
  };
  roles.client = {
    interface = { };
    perInstance =
      { ... }:
      {
        nixosModule =
          { ... }:
          {
            imports = [
              ./client.nix
            ];
          };
      };
  };
  imports = [
    ./management.nix
  ];
}
