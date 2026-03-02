{pkgs, ...}: {
  services.lldap = {
    enable = true;
    settings = {
      ldap_user_pass_file = "TODO";
      jwt_secret_file = "TODO";

      http_url = "https://lldap.echsen.club";
    };
  };

  clan.core.vars.generators = {
    "lldap-admin-password" = {
      files."lldap-admin-password" = {
        secret = true;    
        owner = "lldap";
        group = "lldap";
      };
      runtimeInputs = with pkgs; [
        openssl
      ];
      script = ''
        openssl rand -base64 32 > $out/lldap-admin-password
      '';
    };
    "lldap-jwt-secret" = {
      files."lldap-jwt-secret" = {
        secret = true;    
        owner = "lldap";
        group = "lldap";
      };
      runtimeInputs = with pkgs; [
        openssl
      ];
      script = ''
        openssl rand -base64 32 > $out/lldap-jwt-secret
      '';
    };
  };
}
