{
  config,
  pkgs,
  lib,
  utils,
  ...
}:
let
  package = pkgs.netbird-relay;
  port = 33080;
  exposedAddress = "rel://netbird.echsen.club:443";
  logLevel = "info";
  stunPorts = [ 3478 ];
  stateDir = "/var/lib/netbird-relay";
in
{
  systemd.services.netbird-relay = {
    description = "NetBird Relay Server";
    documentation = [ "https://docs.netbird.io/" ];

    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      # Secret handling: write EnvironmentFile in preStart from LoadCredential,
      # then ExecStart reads it. This avoids exposing the secret in /proc
      # and gives systemd proper process tracking (unlike a script wrapper).
      LoadCredential = [
        "auth-secret:${config.clan.core.vars.generators."netbird-relay-auth".files."password".path}"
      ];

      ExecStart = utils.escapeSystemdExecArgs [
        (lib.getExe' package "netbird-relay")
        "--listen-address"
        ":${toString port}"
        "--exposed-address"
        exposedAddress
        "--log-level"
        logLevel
        "--log-file"
        "console"
        "--enable-stun"
        "--stun-ports"
        (lib.concatStringsSep "," (map toString stunPorts))
      ];

      Restart = "always";
      RuntimeDirectory = "netbird-relay";
      RuntimeDirectoryMode = "0750";
      StateDirectory = "netbird-relay";
      StateDirectoryMode = "0750";
      WorkingDirectory = stateDir;
      DynamicUser = true;

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
      ProtectSystem = "strict";
      RemoveIPC = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;

      # Relay may need to bind to privileged ports when not behind nginx
      AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
      CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
    };

    # Inject the auth secret via EnvironmentFile.
    # LoadCredential makes the file available at $CREDENTIALS_DIRECTORY/auth-secret,
    # then preStart writes an EnvironmentFile that ExecStart picks up.
    # The relay binary reads NB_AUTH_SECRET from the environment via setFlagsFromEnvVars().
    preStart = ''
      umask 077
      echo "NB_AUTH_SECRET=$(< "$CREDENTIALS_DIRECTORY/auth-secret")" > "$RUNTIME_DIRECTORY/env"
    '';

    stopIfChanged = false;
  };

  systemd.services.netbird-relay.serviceConfig.EnvironmentFile = "/run/netbird-relay/env";
}
