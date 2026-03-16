{
  imports = [
    ./caddy.nix
    ./lldap.nix
    ./authelia/authelia.nix
  ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  clan.core.networking.targetHost = "root@doorman";
}
