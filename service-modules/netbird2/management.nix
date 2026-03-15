{
  roles.management = {
    interface =
      {
        lib,
        ...
      }:
      {
        options = {
          domain = lib.mkOption {
            type = lib.types.str;
            description = "Domain for NetBird SSO integration (e.g., echsen.club)";
          };
        };
      };
    perInstance =
      { settings, ... }:
      {
        nixosModule =
          { config, ... }:
          {
            imports = [
              ./secrets/admin-password.nix
              ./secrets/datastore-encryption-key.nix
              ./secrets/relay-auth-secret.nix
              ./secrets/services-setup-key.nix
              ../../machines/doorman/authelia/client-secrets/netbird-client-secret.nix
            ];

            services.netbird.server = {
              management = {
                enable = true;
                port = 8011;
                turnDomain = settings.domain;
                turnPort = 3478;
                dnsDomain = settings.domain;
                domain = settings.domain;
                oidcConfigEndpoint = "https://sso2.echsen.club/.well-known/openid-configuration";
                disableSingleAccountMode = true;

                settings = {
                  DataStoreEncryptionKey._secret =
                    config.clan.core.vars.generators."netbird-data-store-encryption-key".files."encryption-key".path;
                  Relay = {
                    # Addresses = [ "rels://netbird.echsen.club:443" ];
                    Secret._secret = config.clan.core.vars.generators."netbird-relay-auth".files."password".path;
                  };
                  # Stuns = [
                  #   {
                  #     Proto = "udp";
                  #     URI = "stun:netbird.echsen.club:3478";
                  #   }
                  # ];
                  # Signal = {
                  #   URI = "netbird.echsen.club:443";
                  # };
                  HttpConfig = {
                    AuthIssuer = "https://sso2.echsen.club";
                    AuthAudience = "netbird";
                    AuthKeysLocation = "https://sso2.echsen.club/jwks.json";
                    AuthUserIDClaim = "email";
                    IdpSignKeyRefreshEnabled = true;
                    OIDCConfigEndpoint = "https://sso2.echsen.club/.well-known/openid-configuration";
                  };
                  IdpManagerConfig = { };
                  DeviceAuhorizationFlow = {
                    Provider = "hosted";
                    ProviderConfig = {
                      # Audience = "netbird";
                      # AuthorizationEndpoint = "https://sso2.echsen.club/api/oidc/authorization";
                      ClientID = "netbird";
                      ClientSecret._secret =
                        config.clan.core.vars.generators."netbird-client-secret".files."netbird-client-secret".path;
                      # TokenEndpoint = "https://sso2.echsen.club/api/oidc/token";
                      # DeviceAuthEndpoint = "https://sso2.echsen.club/api/oidc/device_authorization";
                      Scope = "openid profile email";
                      UseIDToken = true;
                      # RedirectURLs = [
                      #   "http://localhost:53000/"
                      # ];
                    };
                  };
                  PKCEAuthorizationFlow = {
                    ProviderConfig = {
                      Audience = "netbird";
                      ClientID = "netbird";
                      ClientSecret._secret =
                        config.clan.core.vars.generators."netbird-client-secret".files."netbird-client-secret".path;
                      Domain = "";
                      AuthorizationEndpoint = "https://sso2.echsen.club/api/oidc/authorization";
                      TokenEndpoint = "https://sso2.echsen.club/api/oidc/token";
                      Scope = "openid profile email";
                      RedirectURLs = [
                        "http://localhost:53000/"
                      ];
                      UseIDToken = true;
                      # TokenEndpointAuthMethod = "client_secret_post"; this doesnt exist?
                    };
                  };
                };
              };
              dashboard = {
                enable = true;
                domain = "netbird.echsen.club";
                managementServer = "https://netbird.echsen.club";
                settings = {
                  AUTH_AUTHORITY = "https://sso2.echsen.club";
                  AUTH_REDIRECT_URI = "/auth";
                  AUTH_SILENT_REDIRECT_URI = "/silent-auth";
                  NETBIRD_TOKEN_SOURCE = "accessToken";
                  AUTH_CLIENT_ID = "netbird";
                  # AUTH_AUDIENCE = "none";
                  AUTH_SUPPORTED_SCOPES = "openid profile email";
                  USE_AUTH0 = false;
                };
              };

            };
          };
      };
  };
}
