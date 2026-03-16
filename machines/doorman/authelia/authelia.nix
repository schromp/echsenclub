{ config, pkgs, ... }:
{
  imports = [
    ./client-secrets/netbird-client-secret.nix
    ../../../shared/secrets/smtp-secret.nix
  ];

  services.authelia.instances."EchsenSSO" = {
    enable = true;
    name = "EchsenSSO";
    environmentVariables = {
      AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE =
        config.clan.core.vars.generators."authelia-ldap-password".files."authelia-ldap-password".path;
    };
    settings = {
      server = {
        address = "tcp://127.0.0.1:9091/";
      };
      access_control = {
        default_policy = "one_factor";
      };
      session = {
        cookies = [
          {
            domain = "echsen.club";
            authelia_url = "https://sso2.echsen.club";
            name = "authelia_session";
            same_site = "lax";
            inactivity = "5m";
            expiration = "1h";
            remember_me = "1d";
          }
        ];
      };
      storage = {
        local = {
          path = "/var/lib/authelia-EchsenSSO/db.sqlite3";
        };
      };
      notifier = {
        smtp = {
          address = "smtp://smtp.mailbox.org:587";
          sender = "EchsenSSO <noreply@echsen.club>";
          startup_check_address = "noreply@echsen.club";
          username = config.clan.core.vars.generators."smtp-secret".files.username.value;
          password = "{{ secret \"${config.clan.core.vars.generators.smtp-secret.files.password.path}\" }}";
          subject = "[EchsenSSO] {title}";
        };
      };
      identity_providers = {
        oidc = {
          cors = {
            endpoints = [
              "userinfo"
              "token"
              "authorization"
              "introspection"
              "revocation"
            ];
          };
          claims_policies = {
            netbird = {
              id_token = [ "email" ];
              access_token = [ "email" ];
              custom_claims = {
                email = {
                  name = "email";
                  attribute = "email";
                };
              };
            };
          };
          clients = [
            {
              client_id = "netbird";
              client_name = "NetBird";
              consent_mode = "implicit";
              public = true;
              redirect_uris = [
                "https://netbird2.echsen.club/auth"
                "https://netbird2.echsen.club/silent-auth"
                "http://localhost:53000"
              ];
              audience = [ "netbird" ];
              scopes = [
                "openid"
                "profile"
                "email"
              ];
              grant_types = [
                "authorization_code"
                "refresh_token"
                "urn:ietf:params:oauth:grant-type:device_code"
              ];
              claims_policy = "netbird";
              authorization_policy = "one_factor";
              require_pkce = true;
              pkce_challenge_method = "S256";
              response_types = [ "code" ];
              access_token_signed_response_alg = "RS256";
              userinfo_signed_response_alg = "none";
              token_endpoint_auth_method = "none";
            }
          ];
        };
      };
      authentication_backend = {
        ldap = {
          address = "ldap://127.0.0.1:3890";
          implementation = "lldap";
          base_dn = "dc=echsen,dc=club";
          user = "UID=authelia,OU=people,DC=echsen,DC=club";
          users_filter = "(&(|({username_attribute}={input})(mail={input}))(objectClass=person))";
          attributes = {
            username = "uid";
            display_name = "displayName";
            mail = "mail";
            group_name = "cn";
          };
        };
      };
    };
    secrets = {
      storageEncryptionKeyFile =
        config.clan.core.vars.generators."authelia-storage-encryption-key".files."authelia-storage-encryption-key".path;
      sessionSecretFile =
        config.clan.core.vars.generators."authelia-session-secret".files."authelia-session-secret".path;
      oidcIssuerPrivateKeyFile =
        config.clan.core.vars.generators."authelia-oidc-issuer-private-key".files."authelia-oidc-issuer-private-key".path;
      oidcHmacSecretFile =
        config.clan.core.vars.generators."authelia-oidc-hmac-secret".files."authelia-oidc-hmac-secret".path;
      jwtSecretFile =
        config.clan.core.vars.generators."authelia-jwt-secret".files."authelia-jwt-secret".path;
    };
  };

  users.users."authelia-EchsenSSO" = {
    extraGroups = [ "smtp-secret" ];
  };

  clan.core.vars.generators = {
    "authelia-storage-encryption-key" = {
      files."authelia-storage-encryption-key" = {
        secret = true;
        owner = "authelia-EchsenSSO";
      };
      runtimeInputs = with pkgs; [
        openssl
      ];
      script = ''
        openssl rand -base64 32 > $out/authelia-storage-encryption-key
      '';
    };
    "authelia-session-secret" = {
      files."authelia-session-secret" = {
        secret = true;
        owner = "authelia-EchsenSSO";
      };
      runtimeInputs = with pkgs; [
        openssl
      ];
      script = ''
        openssl rand -base64 32 > $out/authelia-session-secret
      '';
    };
    "authelia-oidc-issuer-private-key" = {
      files."authelia-oidc-issuer-private-key" = {
        secret = true;
        owner = "authelia-EchsenSSO";
      };
      runtimeInputs = with pkgs; [
        openssl
      ];
      script = ''
        openssl genrsa 4096 > $out/authelia-oidc-issuer-private-key
      '';
    };
    "authelia-oidc-hmac-secret" = {
      files."authelia-oidc-hmac-secret" = {
        secret = true;
        owner = "authelia-EchsenSSO";
      };
      runtimeInputs = with pkgs; [
        openssl
      ];
      script = ''
        openssl rand -base64 32 > $out/authelia-oidc-hmac-secret
      '';
    };
    "authelia-jwt-secret" = {
      files."authelia-jwt-secret" = {
        secret = true;
        owner = "authelia-EchsenSSO";
      };
      runtimeInputs = with pkgs; [
        openssl
      ];
      script = ''
        openssl rand -base64 32 > $out/authelia-jwt-secret
      '';
    };
    "authelia-ldap-password" = {
      prompts."authelia-ldap-password" = {
        description = "The password for the authelia ldap user";
        type = "hidden";
        persist = true;
      };
      files."authelia-ldap-password" = {
        secret = true;
        owner = "authelia-EchsenSSO";
      };
    };
  };
}
