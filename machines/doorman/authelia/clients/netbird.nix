{ config, ... }:
{
  services.authelia.instances."EchsenSSO".settings.identity_providers.oidc = {
    claims_policies = {
      netbird = {
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
        client_id = "netbird";
        client_name = "NetBird";
        client_secret =
          config.clan.core.vars.generators."netbird-client-secret".files."netbird-client-hash".value;
        consent_mode = "implicit";
        public = false;
        redirect_uris = [
          "https://netbird.echsen.club/auth"
          "https://netbird.echsen.club/silent-auth"
          "http://localhost:53000"
        ];
        audience = [ "netbird" ];
        scopes = [
          "openid"
          "profile"
          "email"
          "groups"
        ];
        grant_types = [
          "authorization_code"
          "urn:ietf:params:oauth:grant-type:device_code"
        ];
        claims_policy = "netbird";
        authorization_policy = "one_factor";
        require_pkce = false;
        pkce_challenge_method = "S256";
        response_types = [ "code" ];
        access_token_signed_response_alg = "RS256";
        userinfo_signed_response_alg = "none";
        token_endpoint_auth_method = "client_secret_basic";
      }
      {
        client_id = "netbird-dashboard";
        client_name = "NetBird Dashboard";
        consent_mode = "implicit";
        public = true;
        redirect_uris = [
          "https://netbird.echsen.club/auth"
          "https://netbird.echsen.club/silent-auth"
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
}
