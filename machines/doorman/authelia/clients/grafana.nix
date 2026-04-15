{ config, ... }:
{
  imports = [
    ../client-secrets/grafana-client-secret.nix
  ];

  services.authelia.instances."EchsenSSO".settings.identity_providers.oidc = {
    claims_policies = {
      grafana = {
        id_token = [
          "email"
          "name"
          "preferred_username"
          "groups"
        ];
      };
    };

    clients = [
      {
        client_id = "grafana";
        client_name = "grafana";
        client_secret = config.clan.core.vars.generators."grafana-client-secret".files."hash".value;
        public = false;
        require_pkce = true;
        consent_mode = "implicit";
        pkce_challenge_method = "S256";
        redirect_uris = [
          "https://grafana.echsen.club/login/generic_oauth"
        ];
        scopes = [
          "openid"
          "profile"
          "email"
          "roles"
          "groups"
        ];
        response_types = [
          "code"
        ];
        grant_types = [
          "authorization_code"
        ];
        claims_policy = "grafana";
        access_token_signed_response_alg = "RS256";
        userinfo_signed_response_alg = "none";
        token_endpoint_auth_method = "client_secret_basic";
        authorization_policy = "one_factor";
      }
    ];
  };

}
