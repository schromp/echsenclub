{lib, ...}: {
  imports = [
    ./caddy.nix
    ./lldap.nix
    ./authelia/authelia.nix
  ];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  networking.hosts = {
    "127.0.0.1" = [
      "netbird.echsen.club"
      "sso2.echsen.club"
    ];
    "::1" = [ "localhost" ];
  };

  services.resolved = {
    enable = true; # Keep it enabled if you need it
    settings = {
      Resolve = {
        # This ensures resolved looks at /etc/hosts BEFORE trying DNS
        ReadEtcHosts = true;
        # This can help stop it from getting clever with IPv6 loopbacks
        LLMNR = "no";
        MulticastDNS = "no";
        # Forces preference for IPv4
        # Note: 'ipv4' here tells systemd to prefer A records
        ResolveUnicastSingleLabel = "yes";
      };
    };
  };


  clan.core.networking.targetHost = "root@doorman";
}
