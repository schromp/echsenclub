{pkgs, ...}: let
  mySynapseAdmin = pkgs.synapse-admin.overrideAttrs (old: {
    dontFixup = false;
    distPhase =
      (old.distPhase or "")
      + ''
        cat > $out/config.json <<EOF
        {
          "restrictBaseUrl": "https://matrix.echsen.club"
        }
        EOF
      '';
  });
in {
  environment.systemPackages = [pkgs.synapse-admin];

  services.nginx = {
    enable = true;
    clientMaxBodySize = "100m";
    virtualHosts = {
      "matrix-admin.echsen.club" = {
        enableACME = true;
        forceSSL = true;
        locations."/".root = mySynapseAdmin;
      };
    };
  };
}
