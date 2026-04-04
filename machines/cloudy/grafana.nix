{ config, pkgs, ... }:
{
  imports = [
    ../doorman/authelia/client-secrets/grafana-client-secret.nix
  ];
  services.grafana = {
    enable = true;
    settings = {
      server = {
        root_url = "https://grafana.echsen.club";
        http_port = 3000;
      };
      "auth.generic_oauth" = {
        enabled = true;
        name = "EchsenSSO";
        allow_sign_up = true;
        client_id = "grafana";
        scopes = "openid email profile roles groups";
        login_attribute_path = "preferred_username";
        name_attribute_path = "name";
        groups_attribute_path = "groups";
        auth_url = "https://sso2.echsen.club/api/oidc/authorization";
        token_url = "https://sso2.echsen.club/api/oidc/token";
        api_url = "https://sso2.echsen.club/api/oidc/userinfo";
        role_attribute_path = "contains(groups[*], 'GrafanaAdmins') && 'Admin' || contains(groups[*], 'GrafanaEditors') && 'Editor' || 'Viewer'";
        allow_assign_grafana_admin = true;
        auth_style = "InHeader";
        empty_scopes = false;
        use_pkce = true;
      };
    };
    declarativePlugins = with pkgs.grafanaPlugins; [
      grafana-clickhouse-datasource
      grafana-exploretraces-app
      grafana-lokiexplore-app
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
  systemd.services.grafana.serviceConfig.EnvironmentFile =
    config.clan.core.vars.generators."grafana-client-secret".files."secret".path;
}
