{config, ...}: {
  services.kavita = {
    enable = true;
    port = 8101;
    tokenKeyFile = config.clan.core.vars.generators."kavita-token".files."token".path;
  };

  users.users.kavita.extraGroups = [ "jellyfin" ];

  clan.core.vars.generators = {
    "kavita-token" = {
      script = ''
        head -c 64 /dev/urandom | base64 --wrap=0 > $out/token
      '';

      files.token = {
        secret = true;
      };
    };
  };
}
