{
  _class = "clan.service";
  manifest.name = "netbird";
  manifest.readme = builtins.readFile ./README.md;
  roles.relay = {
    description = "NetBird relay machines, which handle data plane traffic and relay it between clients and the management plane.";
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
    description = "NetBird signal machines, which handle control plane traffic and device management.";
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
    description = "NetBird client machines, e.g., desktops and laptops.";
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
