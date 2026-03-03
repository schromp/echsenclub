{
  imports = [
    ./caddy.nix
    ./lldap.nix
  ];

  clan.core.networking.targetHost = "root@doorman";
}
