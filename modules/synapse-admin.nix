{pkgs, ...}: let
  # mySynapseAdmin = pkgs.synapse-admin.overrideAttrs (old: {
  #   fixupPhase =
  #     (old.fixupPhase or "")
  #     + ''
  #       cat > $out/config.json <<EOF
  #       {
  #         "restrictBaseUrl": "https://matrix.echsen.club"
  #       }
  #       EOF
  #     '';
  # });
in {
  environment.systemPackages = [pkgs.synapse-admin];

  services.nginx = {
    enable = true;
    virtualHosts = {
      "matrix-admin.echsen.club" = {
        enableACME = true;
        forceSSL = true;
        locations."/".root = pkgs.synapse-admin;
      };
    };
  };
}
