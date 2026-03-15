{pkgs, ...}: {
  clan.core.vars.generators = {
    "netbird-relay-auth" = {
      files."password" = {
        secret = true;
      };
      runtimeInputs = with pkgs; [
        openssl
      ];
      script = ''
        openssl rand -base64 32 > $out/password
      '';

      share = true;
    };
  };
}
