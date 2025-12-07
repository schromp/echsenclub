{ pkgs, config, ... }:
{
  services.freshrss = {
    enable = true;
    virtualHost = "freshrss.echsen.club";
    baseUrl = "https://freshrss.echsen.club";
    passwordFile = config.clan.core.vars.generators."freshrss-password".files."password".path;
  };

  services.phpfpm.pools.freshrss = {
    phpEnv = {
      OIDC_ENABLED = "1";
      OIDC_PROVIDER_METADATA_URL = "https://sso.echsen.club/realms/echsenclub/.well-known/openid-configuration";
      OIDC_CLIENT_ID = "freshrss";
      OIDC_SCOPES = "openid email profile";
      OIDC_X_FORWARDED_HEADERS = "X-Forwarded-Port X-Forwarded-Proto X-Forwarded-Host";
    };
    phpOptions = "clear_env = no"; 
  };

  systemd.services.phpfpm-freshrss.serviceConfig.EnvironmentFile = config.clan.core.vars.generators."freshrss-keycloak".files."client-secret-env".path;

  clan.core.vars.generators = {
    "freshrss-password" = {
      files."password" = {
        secret = true;
        owner = "freshrss";
        group = "freshrss";
      };
      runtimeInputs = with pkgs; [
        openssl
      ];
      script = ''
        openssl rand -base64 32 > $out/password
      '';
    };

    "freshrss-keycloak" = {
      prompts.client-secret.description = "The oidc client secret";
      prompts.client-secret.persist = true;
      prompts.client-secret.type = "hidden";

      files.client-secret-env = {
        secret = true;
        owner = "freshrss";
        group = "freshrss";
      };

      runtimeInputs = with pkgs; [
        openssl
      ];
      script = ''
        {
          printf "OIDC_CLIENT_SECRET=";  openssl rand -base64 32;  echo
          printf "OIDC_CLIENT_CRYPTO_KEY=";  cat "$prompts/client-secret";  echo
        } > "$out/client-secret-env"
      '';
    };
  };
}
