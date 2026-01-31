{...}: {
  services.ocis = {
    enable = true;
    url = "https://ocis.echsen.club";
    port = 9200;
    environment = {
      STORAGE_USERS_OCIS_ROOT = "/srv/ocis";
      OCIS_EXCLUDE_RUN_SERVICES = "notifications,idp";

      OCIS_INSECURE = "true";
      TLS_INSECURE = "true";
      PROXY_TLS = "false";

      OCIS_OIDC_ISSUER = "https://sso.echsen.club/realms/echsenclub";
      WEB_OIDC_METADATA_URL = "https://sso.echsen.club/realms/echsenclub/.well-known/openid-configuration";
      WEB_OIDC_AUTHORITY = "https://sso.echsen.club/realms/echsenclub";
      PROXY_OIDC_ISSUER = "https://sso.echsen.club/realms/echsenclub";

      PROXY_OIDC_REWRITE_WELLKNOWN = "true";
      WEB_OIDC_CLIENT_ID = "ocis";
      PROXY_AUTOPROVISION_ACCOUNTS = "true";
      PROXY_ROLE_ASSIGNMENT_DRIVER = "oidc";
      PROXY_ROLE_ASSIGNMENT_OIDC_CLAIM = "roles";
      PROXY_OIDC_ALLOWED_CLIENTS = "ocis,ownCloud";
      OCIS_ADMIN_USER_ID = "";
      WEB_OIDC_SCOPE = "openid profile email acr";
      PROXY_USER_OIDC_CLAIM = "sub";
      PROXY_USER_CS3_CLAIM = "username";
      PROXY_AUTOPROVISION_CLAIM_USERNAME = "preferred_username";
    };
  };
  systemd.services.ocis.serviceConfig = {
    ReadWritePaths = [ "/srv/ocis" ];
  };
}
