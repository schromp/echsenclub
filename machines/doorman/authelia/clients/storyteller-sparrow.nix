{ config, pkgs, ... }:
{
  services.authelia.instances."EchsenSSO".settings.identity_providers.oidc = {
    claims_policies = {
      storyteller-sparrow = {
        id_token = [
          "email"
          "name"
          "preferred_username"
          "groups"
        ];
        access_token = [
          "email"
          "name"
          "preferred_username"
          "groups"
        ];
      };
    };

    clients = [
      {
        client_id = "storyteller-sparrow";
        client_name = "StoryTeller Sparrow";
        client_secret =
          config.clan.core.vars.generators."storyteller-sparrow-client-secret".files."hash".value;
        public = false;
        redirect_uris = [
          "https://storyteller.echsen.club/api/v2/auth/callback/authelia"
        ];
        scopes = [
          "openid"
          "profile"
          "email"
          "groups"
        ];
        claims_policy = "storyteller-sparrow";
        authorization_policy = "one_factor";
      }
    ];
  };

  clan.core.vars.generators = {
    "storyteller-sparrow-client-secret" = {
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
