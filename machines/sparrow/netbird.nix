{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ../../modules/password-turn.nix
  ];

  services.netbird = {
    enable = true;
    server = {
      enable = true;
      domain = "netbird.echsen.club";
      # TODO:
      # - Add the setup key to the declarative config
      management = {
        oidcConfigEndpoint = "https://zitadel.echsen.club/.well-known/openid-configuration";
        turnDomain = "netbird.echsen.club";
        logLevel = "DEBUG";
        settings = {
          # https://github.com/netbirdio/netbird/blob/9762b39f29e63033bfbd8a5b68aa320db1ed4584/infrastructure_files/getting-started-with-zitadel.sh#L675
          Signal = {
            URI = "https://signal-sparrow.netbird.echsen.club";
          };
          DataStoreEncryptionKey = {
            _secret = config.clan.core.vars.generators."netbird-data-store-encryption-key".files."encryption-key".path;
          };
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
          DeviceAuthorizationFlow = {
            Provider = "hosted";
            ProviderConfig = {
              Audience = "318708317172118018";
              ClientID = "318708317172118018";
              Scope = "openid";
            };
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
        };
      };
      # https://zitadel.echsen.club/oauth/v2/authorize?client_id=netbird&redirect_uri=https://netbird.echsen.club/#callback&scope=openid profile email&response_type=code&audience=netbird&state=ksC84hhJGhfu1Bj8&nonce=bEP4mZT8GJzf&code_challenge=sTcLyNq4YtyNnZopW9qsywULqWsCC77ejbU_hp_MlhM&code_challenge_method=S256
      dashboard = {
        enable = true;
        enableNginx = true;
        domain = "netbird.echsen.club";
        settings = {
          AUTH_AUTHORITY = "https://zitadel.echsen.club";
          AUTH_CLIENT_ID = "318708317172118018";
        };
      };
      signal = {
        enable = true;
        port = 8013;
        domain = "signal-sparrow.netbird.echsen.club";
      };
      #   coturn = {
      #     enable = true;
      #   };
    };

    clients = {
      "echsengang" = {
        openFirewall = true;
        ui.enable = false;
        port = 51820;
        environment = {
          NB_SETUP_KEY = config.clan.core.vars.generators."netbird-services-setup-key".files."netbird-services-setup-key".value;
          NB_LOG_LEVEL = lib.mkForce "debug";
        };
        config = {
          ManagementURL = {
            Scheme = "https";
            Opaque = "";
            User = null;
            Host = "netbird.echsen.club:443";
          };
        };
      };
    };
  };

  clan.core.vars.generators = {
    "netbird-data-store-encryption-key" = {
      files."encryption-key" = {
        secret = true;
      };
      runtimeInputs = with pkgs; [
        openssl
      ];
      script = ''
        openssl rand -base64 32 > $out/encryption-key
      '';
    };

    "netbird-zitadel-client-secret" = {
      prompts.netbird-zitadel-client-secret.description = "The zitadel client secret for the netbird user";
      prompts.netbird-zitadel-client-secret.persist = true;

      files.netbird-zitadel-client-secret = {
        secret = true;
      };
    };

    "netbird-services-setup-key" = {
      prompts.netbird-services-setup-key.description = "The zitadel client secret for the netbird user";
      prompts.netbird-services-setup-key.persist = true;

      files.netbird-services-setup-key = {
        secret = false;
      };
      share = true;
    };
  };
}
