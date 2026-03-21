{ pkgs, config, ... }:
{
  virtualisation.oci-containers.containers."storyteller" = {
    image = "registry.gitlab.com/storyteller-platform/storyteller:latest";
    autoStart = true;

    user = "2000:1500";
    environment = {
      AUTH_URL = "https://storyteller.echsen.club/api/v2/auth";
      ENABLE_WEB_READER = "true";
    };
    environmentFiles = [
      config.clan.core.vars.generators."storyteller-secret".files."secret".path
    ];

    ports = [
      "8001:8001"
    ];

    volumes = [
      "/var/lib/storyteller:/data"
      "/srv/media/audiobooks:/audiobooks:rw"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/storyteller 0750 2000 66000 - -"
  ];

  clan.core.vars.generators."storyteller-secret" = {
    files."secret" = {
      secret = true;
    };

    runtimeInputs = with pkgs; [
      openssl
    ];

    script = ''
      SECRET_VAL=$(openssl rand -base64 32)
      echo "STORYTELLER_SECRET_KEY=$SECRET_VAL" > "$out/secret"
    '';
  };
}
