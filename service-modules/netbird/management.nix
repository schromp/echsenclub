{
  inputs,
  pkgs,
  config,
  ...
}: {
  services.netbird.server = {
    management = {
      enable = true;
      port = 8011;
      package = inputs.netbird-new-module.legacyPackages.${pkgs.system}.netbird-server;
      # package = (inputs.netbird-new-module + "/nixos/pkgs/by-name/ne/netbird-server/package.nix");
      turnDomain = "coturn-cloudy.echsen.club";
      turnPort = 3478;
      dnsDomain = "netbird.echsen.club";
      domain = "netbird.echsen.club";

      oidcConfigEndpoint = "https://sso.echsen.club/realms/echsenclub/.well-known/openid-configuration";
      logLevel = "DEBUG";
      settings = {
        DataStoreEncryptionKey._secret = config.clan.core.vars.generators."netbird-data-store-encryption-key".files."encryption-key".path;
        Relay = {
          Addresses = ["netbird.echsen.club"];
          Secret._secret = config.clan.core.vars.generators."netbird-relay-auth".files."password".path;
        };
        Signal = {
          URI = "netbird.echsen.club:443";
        };
        TURNConfig = {
          Turns = [
            {
              Proto = "udp";
              URI = "turn:coturn-cloudy.echsen.club:3478";
              Username = "netbird";
              Password._secret = config.clan.core.vars.generators."coturn-password".files."password".path;
            }
          ];
          Secret._secret = config.clan.core.vars.generators."coturn-password".files."password".path;
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
          Provider = "keycloak";
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
      enableNginx = true;
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
