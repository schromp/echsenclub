{ config, pkgs, ... }:
{
  services.authelia.instances."EchsenSSO".settings.identity_providers.oidc = {
    clients = [
      {
        client_id = "audiobookshelf-sparrow";
        client_name = "AudiobookShelf Sparrow";
        client_secret =
          config.clan.core.vars.generators."audiobookshelf-sparrow-client-secret".files."hash".value;
        public = false;
        require_pkce = true;
        pkce_challenge_method = "S256";
        redirect_uris = [
          "https://audiobookshelf.echsen.club/auth/openid/callback"
          "https://audiobookshelf.echsen.club/auth/openid/mobile-redirect"
          "audiobookshelf://oauth"
          "plappa://oauth"
        ];
        scopes = [
          "openid"
          "profile"
          "email"
          "groups"
        ];
        response_types = [
          "code"
        ];
        grant_types = [
          "authorization_code"
        ];
        access_token_signed_response_alg = "none";
        userinfo_signed_response_alg = "none";
        token_endpoint_auth_method = "client_secret_basic";
        authorization_policy = "one_factor";
      }
    ];
  };

  clan.core.vars.generators = {
    "audiobookshelf-sparrow-client-secret" = {
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
