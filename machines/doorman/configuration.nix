{ lib, ... }:
{
  clan.core.sops.defaultGroups = [ "admins" ];

  imports = [
    ./caddy.nix
    ./lldap.nix
    ./authelia/authelia.nix
  ];

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [
      3478
    ];
  };

  services.resolved = {
    enable = true;
  };

  # this is needed because the management server runs on the same server as the client
  services.netbird.clients."echsenclub".config.ManagementURL.Host = lib.mkForce "[::]:8011";

  clan.core.networking.targetHost = "root@doorman";
}
