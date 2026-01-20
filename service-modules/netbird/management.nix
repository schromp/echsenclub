{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  services.netbird.server = {
    management = {
      enable = true;
      port = 8011;
      package = pkgs.netbird-management.overrideAttrs (oldAttrs: rec {
        version = "0.63.0";
        src = oldAttrs.src.override {
          tag = "v${version}";
          hash = "sha256-PNxwbqehDtBNKkoR5MtnmW49AYC+RdiXpImGGeO/TPg=";
        };
        vendorHash = "sha256-iTfwu6CsYQYwyfCax2y/DbMFsnfGZE7TlWE/0Fokvy4=";
      });
      turnDomain = "coturn-cloudy.echsen.club";
      turnPort = 3478;
      dnsDomain = "netbird.echsen.club";
      domain = "netbird.echsen.club";

      oidcConfigEndpoint = "https://sso.echsen.club/realms/echsenclub/.well-known/openid-configuration";
      # logLevel = "DEBUG";
      settings = {
        DataStoreEncryptionKey._secret = config.clan.core.vars.generators."netbird-data-store-encryption-key".files."encryption-key".path;
        Relay = {
          Addresses = ["rels://netbird.echsen.club:443"];
          Secret._secret = config.clan.core.vars.generators."netbird-relay-auth".files."password".path;
        };
        Signal = {
          URI = "netbird.echsen.club:443";
        };
        IdpManagerConfig = {
          ManagerType = "keycloak";
          ClientConfig = {
            Issuer = "https://sso.echsen.club/realms/echsenclub";
            TokenEndpoint = "https://sso.echsen.club/realms/echsenclub/protocol/openid-connect/token";
            ClientID = "netbird-backend";
            ClientSecret = {
              _secret = config.clan.core.vars.generators."keycloak-netbird-backend-client-secret".files."keycloak-netbird-backend-client-secret".path;
            };
            GrantType = "client_credentials";
            Scope = "openid profile email offline_access api";
            Audience = "netbird-client";
          };
          ExtraConfig = {
            ManagementEndpoint = "https://sso.echsen.club/admin/realms/echsenclub";
            AdminEndpoint = "https://sso.echsen.club/admin/realms/echsenclub";
          };
          SignkeyRefresh = true;
        };
        ExtraConfig = {
          Password._secret = config.clan.core.vars.generators."netbird-admin-password".files."password".path;
          Username = "admin";
        };
        PKCEAuthorizationFlow = {
          ProviderConfig = {
            Audience = "netbird-client";
            ClientID = "netbird-client";
            Scope = "openid profile email offline_access api";
            AuthorizationEndpoint = "https://sso.echsen.club/realms/echsenclub/protocol/openid-connect/auth";
            RedirectURLs = [
              "http://localhost:53000/"
            ];
          };
        };
        DeviceAuthorizationFlow = {
          Provider = "hosted";
          ProviderConfig = {
            ClientID = "netbird-client";
            Audience = "netbird-client";
            Domain = "https://sso.echsen.club/realms/echsenclub";
            TokenEndpoint = "https://sso.echsen.club/realms/echsenclub/protocol/openid-connect/token";
            DeviceAuthEndpoint = "https://sso.echsen.club/realms/echsenclub/protocol/openid-connect/auth/device";
            Scope = "openid profile email offline_access api";
            # UseIDToken = false;
          };
        };
      };
    };
    dashboard = {
      enable = true;
      package = pkgs.netbird-dashboard.overrideAttrs (
        finalAttrs: prevAttrs: {
          version = "2.27.2";

          src = prevAttrs.src.override {
            rev = "v${finalAttrs.version}";
            hash = "sha256-lwPPXDN2hj4QDI5lKTrmC+NnWuGuGS0CEgsL/VfOQk0=";
          };

          npmDepsHash = "sha256-e4Uxy1bwR3a+thIkaNWpAwDvIJyTbM5TwVy+YVD0CQQ";

          npmDeps = pkgs.fetchNpmDeps {
            inherit (finalAttrs) src;
            name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
            hash = finalAttrs.npmDepsHash;
          };
        }
      );
      # enableNginx = true;
      domain = "netbird.echsen.club";
      managementServer = "https://netbird.echsen.club";
      settings = {
        AUTH_AUTHORITY = "https://sso.echsen.club/realms/echsenclub";
        AUTH_CLIENT_ID = "netbird-client";
        AUTH_SUPPORTED_SCOPES = "openid profile email api";
        USE_AUTH0 = false;
      };
    };
  };
}
