{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./secrets/services-setup-key.nix
  ];

  services.netbird.clients."echsenclub" = {
    port = 51820;
    environment = {
      NB_MANAGEMENT_URL = "https://netbird.echsen.club";
      NB_SETUP_KEY_FILE = config.clan.core.vars.generators."netbird-services-setup-key".files."netbird-services-setup-key".path;
    };
  };
  # DAA23A80-F5D6-4F3B-8082-4D0B2BA186B2

  # users.users."netbird-echsenclub" = {
  #   isSystemUser = true;
  #   group = "netbird-echsenclub";
  #   home = "/var/lib/netbird-echsenclub";
  # };
  # users.groups."netbird-echsenclub" = {};
  #
  # systemd.services.netbird-echsenclub = {
  #   description = "Netbird Mesh VPN Client";
  #   after = ["network.target"];
  #   wantedBy = ["multi-user.target"];
  #   serviceConfig = {
  #     Type = "simple";
  #     User = "netbird-echsenclub";
  #     Group = "netbird-echsenclub";
  #     RuntimeDirectory = "netbird";
  #     StateDirectory = "netbird-echsenclub";
  #     WorkingDirectory = "/var/lib/netbird-echsenclub";
  #     AmbientCapabilities = ["CAP_NET_ADMIN" "CAP_NET_RAW"];
  #     ProtectSystem = "strict";
  #     ProtectHome = "yes";
  #     PrivateTmp = true;
  #     Restart = "always";
  #     # EnvironmentFile = config.clan.core.vars.generators."netbird-services-setup-key".files."secret-envs".path;
  #     Environment = [
  #       "NB_SETUP_KEY_FILE=${config.clan.core.vars.generators."netbird-services-setup-key".files."netbird-services-setup-key".path}"
  #       "NB_MANAGEMENT_URL=https://netbird.echsen.club"
  #       "NB_LOG_FILE=console"
  #       "NB_LOG_LEVEL=DEBUG"
  #       "NB_CONFIG=/var/lib/netbird-echsenclub/config.json"
  #     ];
  #     ExecStart = "${pkgs.netbird}/bin/netbird service run";
  #   };
  # };
  #
  # systemd.services.netbird-echsenclub-register = {
  #   description = "Netbird Registration (after main service)";
  #   after = ["netbird-echsenclub.service"];
  #   partOf = ["netbird-echsenclub.service"];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     User = "netbird-echsenclub";
  #     Group = "netbird-echsenclub";
  #     WorkingDirectory = "/var/lib/netbird-echsenclub";
  #     Environment = [
  #       "NB_MANAGEMENT_URL=https://netbird.echsen.club"
  #       "NB_SETUP_KEY=your-setup-key"
  #       "NB_CONFIG=/var/lib/netbird-echsenclub/config.json"
  #       "NB_LOG_FILE=console"
  #     ];
  #     ExecStart = "${pkgs.netbird}/bin/netbird up";
  #   };
  #   # unitConfig = {
  #   #   ConditionPathExists = "!/var/lib/netbird-echsenclub/config.json";
  #   # };
  #   # RemainAfterExit = true;
  # };
}
