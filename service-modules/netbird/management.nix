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
      turnDomain = "relay-netbird.echsen.club";
      dnsDomain = "netbird.echsen.club";
      domain = "netbird.echsen.club";

      oidcConfigEndpoint = "https://zitadel.echsen.club/.well-known/openid-configuration";
      logLevel = "DEBUG";
      settings = {
        DataStoreEncryptionKey._secret = config.clan.core.vars.generators."netbird-data-store-encryption-key".files."encryption-key".path;
        IdpManagerConfig = {
          ManagerType = "zitadel";
          ClientConfig = {
            Issuer = "https://zitadel.echsen.club/oauth/v2";
            TokenEndpoint = "https://zitadel.echsen.club/oauth/v2/token";
            ClientID = "netbird";
            ClientSecret = {
              _secret = config.clan.core.vars.generators."netbird-zitadel-client-secret".files."netbird-zitadel-client-secret".path;
            };
            GrantType = "client_credentials";
          };
          ExtraConfig = {
            ManagementEndpoint = "https://zitadel.echsen.club/management/v1";
          };
          SignkeyRefresh = true;
        };
        ExtraConfig = {
          Password._secret = config.clan.core.vars.generators."netbird-admin-password".files."password".path;
          Username = "admin";
        };
        PKCEAuthorizationFlow = {
          ProviderConfig = {
            Audience = "318708317172118018";
            ClientID = "318708317172118018";
            Scope = "openid profile email offline_access api";
            RedirectURLs = [
              "http://localhost:53000/"
              "http://localhost:54000/"
              "https://netbird.echsen.club"
              "https://netbird.echsen.club/auth"
              "https://netbird.echsen.club/silent-auth"
              "https://netbird.echsen.club/#callback"
            ];
          };
        };
        DeviceAuthorizationFlow = {
          Provider = "zitadel";
          ProviderConfig = {
            Audience = "318708317172118018";
            ClientID = "318708317172118018";
            Domain = "zitadel.echsen.club";
            TokenEndpoint = null;
            DeviceAuthEndpoint = "";
            Scope = "openid profile email offline_access api";
            UseIDToken = false;
          };
        };
      };
    };
    dashboard = {
      enable = true;
      enableNginx = true;
      domain = "netbird.echsen.club";
      managementServer = "";
      settings = {
        AUTH_AUTHORITY = "https://zitadel.echsen.club";
        AUTH_CLIENT_ID = "318708317172118018";
      };
    };
  };
}
