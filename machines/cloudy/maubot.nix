{ config, pkgs, ... }:
{
  services.maubot = {
    enable = true;
    extraConfigFile = config.clan.core.vars.generators."maubot".files."secrets.yaml".path;
    settings = {
      server = {
        public_url = "https://maubot.echsen.club";
        port = 29316;
      };
      homeservers = {
        "echsen.club" = {
          url = "https://matrix.echsen.club";
        };
      };
    };
    plugins = with config.services.maubot.package.plugins; [
      webhook
    ];
  };

  clan.core.vars.generators = {
    "maubot" = {
      files."secrets.yaml" = {
        secret = true;
        owner = "maubot";
        group = "maubot";
      };
      runtimeInputs = with pkgs; [
        openssl
        pwgen
      ];
      script = ''
              # Generate a random password
              password=$(openssl rand -base64 32)
              secret=$(pwgen -s 32 1)

              # Create the YAML file
              cat > $out/secrets.yaml <<EOF
        server:
          unshared_secret: "$secret"
        admins:
          schromp: "$password"
        EOF
      '';
      share = true;
    };
  };

  # THis is not yet in code so i pasted here to save it
  # path: /send_alert
  # method: POST
  # room: '!fGHwJTfObxDWKFeeEe:echsen.club'
  # message: |
  #     # 🚨 Alert Summary 🚨
  #
  #     **Status**: {{ json.status|upper }}
  #
  #     **Total Alerts**: {{ json.alerts|length }}
  #
  #
  #     {% for alert in json.alerts %}
  #     ---
  #     ### Alert #{{ loop.index }}: {{ alert.labels.alertname }}
  #
  #
  #     **Severity**: {{ alert.labels.severity|upper }}
  #
  #     **Summary**: {{ alert.annotations.summary }}
  #
  #     {% endfor %}
  # message_format: markdown
  # message_type: m.text
  # auth_type: basic
  # auth_token: echsmachina:wtaRmBfAQJRhb7
  # force_json: false
  # ignore_empty_messages: false
}
