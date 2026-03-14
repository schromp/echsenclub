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
        default_policy = "one_factor"; # TODO:
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
          clients = [
            {
              client_id = "netbird";
              client_name = "NetBird";
              redirect_uris = [ "https://netbird2.echsen.club" ];
              client_secret =
                config.clan.core.vars.generators."netbird-client-secret".files."netbird-client-hash".value;
              authorization_policy = "one_factor";
              public = false;
              require_pkce = false;
              pkce_challenge_method = "";
              grant_types = [ "authorization_code" ];
              response_types = [ "code" ];
              scopes = [
                "openid"
                "profile"
                "email"
              ];
              access_token_signed_response_alg = "none";
              userinfo_signed_response_alg = "none";
              token_endpoint_auth_method = "client_secret_post";
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
