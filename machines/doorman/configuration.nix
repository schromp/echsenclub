{
  imports = [
    ./caddy.nix
    ./lldap.nix
    ./authelia/authelia.nix
    
  ];

  clan.core.networking.targetHost = "root@doorman";
}
