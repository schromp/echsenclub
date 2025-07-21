{
  pkgs,
  config,
  inputs,
  ...
}: let
  netbird-domain = "netbird.echsen.club";
in {
  disabledModules = [
    "services/networking/netbird/server.nix"
    "services/networking/netbird/signal.nix"
    "services/networking/netbird/management.nix"
    "services/networking/netbird/dashboard.nix"
    "services/networking/netbird/coturn.nix"
  ];

  imports = [
    # ../../modules/password-turn.nix
    (inputs.netbird-new-module + "/nixos/modules/services/networking/netbird/server.nix")
    (inputs.netbird-new-module + "/nixos/modules/services/networking/netbird/dashboard.nix")
    (inputs.netbird-new-module + "/nixos/modules/services/networking/netbird/relay.nix")
    (inputs.netbird-new-module + "/nixos/modules/services/networking/netbird/signal.nix")
    (inputs.netbird-new-module + "/nixos/modules/services/networking/netbird/coturn.nix")
    (inputs.netbird-new-module + "/nixos/modules/services/networking/netbird/proxy.nix")
  ];

  services.netbird = {
    server = {
      enable = true;
      domain = "${netbird-domain}";

      # proxy = {
      #   enableNginx = true;
      #   domain = "${netbird-domain}";
      #   managementAddress = "127.0.0.1:8011";
      #
      # };

      management = {
        port = 8011;
        package = inputs.netbird-new-module.legacyPackages.${pkgs.system}.netbird-server;
        # package = (inputs.netbird-new-module + "/nixos/pkgs/by-name/ne/netbird-server/package.nix");

        oidcConfigEndpoint = "https://zitadel.echsen.club/.well-known/openid-configuration";
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
        };
      };

      dashboard = {
        enable = true;
        enableNginx = true;
        domain = "netbird.echsen.club";
        settings = {
          AUTH_AUTHORITY = "https://zitadel.echsen.club";
          AUTH_CLIENT_ID = "318708317172118018";
        };
      };

      relay = {
        package = inputs.netbird-new-module.legacyPackages.${pkgs.system}.netbird-server;
        authSecretFile = config.clan.core.vars.generators."netbird-data-store-encryption-key".files."encryption-key".path; # TODO:
      };

      # coturn = {
      #   enable = true;
      #   passwordFile = config.clan.core.vars.generators."netbird-data-store-encryption-key".files."encryption-key".path; # TODO:
      # };
      signal = {
        package = inputs.netbird-new-module.legacyPackages.${pkgs.system}.netbird-server;
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
        openssl rand -base64 32 > $out-server/encryption-key
      '';
    };

    "netbird-admin-password" = {
      files."password" = {
        secret = true;
      };
      runtimeInputs = with pkgs; [
        openssl
      ];
      script = ''
        openssl rand -base64 32 > $out/password
      '';
      share = false;
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
