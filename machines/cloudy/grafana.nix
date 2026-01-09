{config, pkgs, ...}: {
  services.grafana = {
    enable = true;
    settings = {
      server = {
        root_url = "https://grafana.echsen.club";
        http_port = 3000;
      };
      "auth.generic_oauth" = {
        enabled = true;
        name = "0.0.0.0";
        allow_sign_up = true;
        client_id = "grafana";
        scopes = "openid email profile offline_access roles";
        email_attribute_path = "email";
        login_attribute_path = "username";
        name_attribute_path = "full_name";
        auth_url = "https://sso.echsen.club/realms/echsenclub/protocol/openid-connect/auth";
        token_url = "https://sso.echsen.club/realms/echsenclub/protocol/openid-connect/token";
        api_url = "https://sso.echsen.club/realms/echsenclub/protocol/openid-connect/userinfo";
        role_attribute_path = "contains(resource_access.grafana.roles[*], 'admin') && 'Admin' || contains(resource_access.grafana.roles[*], 'editor') && 'Editor' || 'Viewer'";
        grafana_admin_attribute_path = "contains(resource_access.grafana.roles[*], 'server_admin')";
        allow_assign_grafana_admin = true;
      };
    };
    declarativePlugins = with pkgs.grafanaPlugins; [
      grafana-clickhouse-datasource
    ];
    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Clickhouse";
          type = "grafana-clickhouse-datasource";
          uid = "clickhouse";
          url = "sparrow.internal.echsen.club"; 
          jsonData = {
            defaultDatabase = "default";
            port = 9901;
            protocol = "http";
            server = "sparrow.internal.echsen.club";
            username = "default";
            tlsSkipVerify = true;
          };
        }
      ];
    };
  };
  systemd.services.grafana.serviceConfig.EnvironmentFile = config.clan.core.vars.generators."keycloak-grafana".files."client-secret".path;
  clan.core.vars.generators = {
    "keycloak-grafana" = {
      prompts.client-secret-prompt.description = "The keycloak client secret for grafana";
      prompts.client-secret-prompt.persist = true;
      prompts.client-secret-prompt.type = "hidden";

      script = ''
        {
          printf "GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET="; cat "$prompts/client-secret-prompt"; echo
        } > "$out/client-secret"
      '';

      files.client-secret = {
        secret = true;
        owner = "grafana";
        group = "grafana";
      };
    };
  };
}
