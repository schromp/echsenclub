{ config, pkgs, ... }:
{
  services.authelia.instances."EchsenSSO".settings.identity_providers.oidc = {
    lifespans.custom.ocis = {
      access_token = "2 days";
      refresh_token = "3 days";
    };

    clients = [
      {
        client_id = "ocis-sparrow";
        client_name = "ocis Sparrow";
        lifespan = "ocis";
        public = true;
        require_pkce = true;
        pkce_challenge_method = "S256";
        authorization_policy = "one_factor";
        scopes = [
          "openid"
          "profile"
          "email"
          "groups"
          "offline_access"
          "acr"
        ];
        redirect_uris = [
          "https://ocis.echsen.club/"
          "https://ocis.echsen.club/oidc-callback.html"
          "https://ocis.echsen.club/oidc-silent-redirect.html"
          "https://ocis.echsen.club/apps/openidconnect/redirect"
        ];
        response_types = [
          "code"
        ];
        grant_types = [
          "authorization_code"
          "refresh_token"
        ];
        access_token_signed_response_alg = "none";
        userinfo_signed_response_alg = "none";
        token_endpoint_auth_method = "none";
      }
      {
        client_id = "ocis-desktop-sparrow";
        client_name = "ocis Desktop Sparrow";
        authorization_policy = "one_factor";
        client_secret = config.clan.core.vars.generators."ocis-sparrow-desktop-client-secret".files."hash".value;
        public = false;
        require_pkce = true;
        pkce_challenge_method = "S256";
        scopes = [
          "openid"
          "profile"
          "email"
          "groups"
          "offline_access"
        ];
        redirect_uris = [
          "https://127.0.0.1"
          "https://localhost"
        ];
        response_types = [
          "code"
        ];
        grant_types = [
          "authorization_code"
          "refresh_token"
        ];
        access_token_signed_response_alg = "none";
        userinfo_signed_response_alg = "none";
        token_endpoint_auth_method = "client_secret_basic";
      }
      {
        client_id = "e4rAsNUSIUs0lF4nbv9FmCeUkTlV9GdgTLDH1b5uie7syb90SzEVrbN7HIpmWJeD";
        authorization_policy = "one_factor";
        client_name = "ocis Android Sparrow";
        client_secret = config.clan.core.vars.generators."ocis-sparrow-android-client-secret".files."hash".value;
        public = false;
        require_pkce = true;
        pkce_challenge_method = "S256";
        scopes = [
          "openid"
          "profile"
          "email"
          "groups"
          "offline_access"
        ];
        redirect_uris = [
          "oc://android.owncloud.com"
        ];
        response_types = [
          "code"
        ];
        grant_types = [
          "authorization_code"
          "refresh_token"
        ];
        access_token_signed_response_alg = "none";
        userinfo_signed_response_alg = "none";
        token_endpoint_auth_method = "client_secret_post";
      }
      {
        client_id = "ocis-ios-sparrow";
        authorization_policy = "one_factor";
        client_name = "ocis IOS Sparrow";
        client_secret = config.clan.core.vars.generators."ocis-sparrow-ios-client-secret".files."hash".value;
        public = false;
        require_pkce = true;
        pkce_challenge_method = "S256";
        scopes = [
          "openid"
          "profile"
          "email"
          "groups"
          "offline_access"
        ];
        redirect_uris = [
          "oc://ios.owncloud.com"
          "oc.ios://ios.owncloud.com"
        ];
        response_types = [
          "code"
        ];
        grant_types = [
          "authorization_code"
          "refresh_token"
        ];
        access_token_signed_response_alg = "none";
        userinfo_signed_response_alg = "none";
        token_endpoint_auth_method = "client_secret_basic";
      }
    ];
  };


  clan.core.vars.generators = {
    "ocis-sparrow-desktop-client-secret" = {
      files = {
        "secret" = {
          secret = true;
          owner = "authelia-EchsenSSO";
        };
        "hash" = {
          secret = false;
        };
      };
      runtimeInputs = with pkgs; [
        authelia
        gnugrep
      ];
      script = ''
        output=$(authelia crypto hash generate pbkdf2 --variant sha512 --random --random.length 72 --random.charset rfc3986)
        password=$(echo "$output" | grep -oP 'Random Password: \K.*')
        hash=$(echo "$output" | grep -oP 'Digest: \K.*')
        echo -n "$password" > "$out/secret"
        echo -n "$hash" > "$out/hash"
      '';
      share = false; # secret needs to be entered manually so shared makes no sense
    };
    "ocis-sparrow-android-client-secret" = {
      files = {
        "secret" = {
          secret = true;
          owner = "authelia-EchsenSSO";
        };
        "hash" = {
          secret = false;
        };
      };
      runtimeInputs = with pkgs; [
        authelia
        gnugrep
      ];
      script = ''
        output=$(authelia crypto hash generate pbkdf2 --variant sha512 --random --random.length 72 --random.charset rfc3986)
        password=$(echo "$output" | grep -oP 'Random Password: \K.*')
        hash=$(echo "$output" | grep -oP 'Digest: \K.*')
        echo -n "$password" > "$out/secret"
        echo -n "$hash" > "$out/hash"
      '';
      share = false; # secret needs to be entered manually so shared makes no sense
    };
    "ocis-sparrow-ios-client-secret" = {
      files = {
        "secret" = {
          secret = true;
          owner = "authelia-EchsenSSO";
        };
        "hash" = {
          secret = false;
        };
      };
      runtimeInputs = with pkgs; [
        authelia
        gnugrep
      ];
      script = ''
        output=$(authelia crypto hash generate pbkdf2 --variant sha512 --random --random.length 72 --random.charset rfc3986)
        password=$(echo "$output" | grep -oP 'Random Password: \K.*')
        hash=$(echo "$output" | grep -oP 'Digest: \K.*')
        echo -n "$password" > "$out/secret"
        echo -n "$hash" > "$out/hash"
      '';
      share = false; # secret needs to be entered manually so shared makes no sense
    };
  };
}
