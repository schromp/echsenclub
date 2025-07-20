{
  config,
  pkgs,
  clan-core,
  ...
}: {
  imports = [
    ../../modules/shared.nix

    ../../modules/synapse-admin.nix

    clan-core.clanModules.matrix-synapse
  ];
  # Put your username here for login
  users.users.user.name = "lk";

  # Set this for clan commands use ssh i.e. `clan machines update`
  # If you change the hostname, you need to update this line to root@<new-hostname>
  # This only works however if you have avahi running on your admin machine else use IP
  clan.core.networking.targetHost = "root@cloudy";

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22
      80
      443
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRat12+538VwG/IAv5R4AjdNYz/GATO7ULQnXtYC2HK lk@tower
    ''
  ];

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  clan.nginx.acme.email = "lennart@koziollek.com";
  clan.matrix-synapse = {
    app_domain = "matrix.echsen.club";
    server_tld = "echsen.club";
    users = {
      schromp = {
        name = "schromp";
        admin = true;
      };
    };
  };

  services.matrix-synapse.settings = {
    max_upload_size = "100M";
  };

  services.netbird = {
    server.coturn = {
      enable = true;
      domain = "coturn-cloudy.netbird.echsen.club";
      passwordFile = config.clan.core.vars.generators."netbird-turn-cloudy-password".files."turn-cloudy-password".path;
      useAcmeCertificates = true;
    };
  };
}
