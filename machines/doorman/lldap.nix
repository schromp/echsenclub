{config, pkgs, ...}: {
  services.lldap = {
    enable = true;
    settings = {
      ldap_user_pass_file = "/run/credentials/lldap.service/admin_password";
      jwt_secret_file = "/run/credentials/lldap.service/jwt_secret";
      ldap_base_dn = "dc=echsen,dc=club";
      http_url = "https://lldap.echsen.club";
    };
  };

  users.users.lldap = {
    isSystemUser = true;
    group = "lldap";
  };
  users.groups.lldap = {};

  systemd.services.lldap.serviceConfig = {
    LoadCredential = [
      "admin_password:${config.clan.core.vars.generators."lldap-admin-password".files."lldap-admin-password".path}"
      "jwt_secret:${config.clan.core.vars.generators."lldap-jwt-secret".files."lldap-jwt-secret".path}"
    ];
  };


  clan.core.vars.generators = {
    "lldap-admin-password" = {
      files."lldap-admin-password" = {
        secret = true;    
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
