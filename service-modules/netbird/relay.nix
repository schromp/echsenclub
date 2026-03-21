{
  config,
  pkgs,
  lib,
  ...
}:
let
  package = pkgs.netbird-relay;
  port = 33080;
  exposedAddress = "rel://netbird.echsen.club:443";
in
{
  systemd.services.netbird-relay = {
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      NB_EXPOSED_ADDRESS = exposedAddress;
      NB_LISTEN_ADDRESS = ":${toString port}";
    };

    script = ''
      export NB_AUTH_SECRET="$(<${config.clan.core.vars.generators."netbird-relay-auth".files."password".path})"
      ${lib.getExe package}
    '';

    serviceConfig = {
      Restart = "always";
      RuntimeDirectory = "netbird-mgmt";
      StateDirectory = "netbird-mgmt";
      WorkingDirectory = "/var/lib/netbird-mgmt";

      # hardening
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateMounts = true;
      PrivateTmp = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectSystem = true;
      RemoveIPC = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
    };

    stopIfChanged = false;
  };
}
