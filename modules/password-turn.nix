{pkgs, ...}: {
  clan.core.vars.generators = {
    "netbird-turn-cloudy-password" = {
      files."turn-cloudy-password" = {
        secret = false;
      };
      runtimeInputs = with pkgs; [
        openssl
      ];
      script = ''
        openssl rand -base64 32 > $out/turn-cloudy-password
      '';

      share = false;
    };
  };
}
