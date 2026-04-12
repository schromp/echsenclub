{ ... }:
{
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

      OCIS_OIDC_ISSUER = "https://sso2.echsen.club";
      PROXY_OIDC_REWRITE_WELLKNOWN = "true";
      WEB_OIDC_CLIENT_ID = "ocis-sparrow";
      PROXY_AUTOPROVISION_ACCOUNTS = "true";
      PROXY_ROLE_ASSIGNMENT_DRIVER = "default";
      PROXY_OIDC_ACCESS_TOKEN_VERIFY_METHOD = "none";
      PROXY_OIDC_ALLOWED_CLIENTS = "ocis-sparrow";
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
