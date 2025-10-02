{ pkgs, ... }:
let
  mySynapseAdmin = pkgs.synapse-admin.overrideAttrs (old: {
    dontFixup = false;
    distPhase = (old.distPhase or "") + ''
      cat > $out/config.json <<EOF
      {
        "restrictBaseUrl": "https://matrix.echsen.club"
      }
      EOF
    '';
  });
in
{
  environment.systemPackages = [ pkgs.synapse-admin ];

  services.nginx = {
    enable = true;
    clientMaxBodySize = "100m";
    virtualHosts = {
      "matrix-admin.echsen.club" = {
        listenAddresses = [ "100.117.81.56" ]; # Only listen on the NetBird interface
        useACMEHost = "matrix-admin.echsen.club";
        forceSSL = true;
        locations."/".root = mySynapseAdmin;
      };
    };
  };
}
